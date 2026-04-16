//
//  NetworkToolQueueManager.swift
//  DepartmentLessonApp
//
//  Created by mc on 4/13/26.
//

import CryptoKit

// MARK: 去重快照
struct NetworkToolSnapshot {
    let urlString: String?
    let params: [String: Any]?
    let uploadData: Data?
    let showHub: Bool
    let isUpload: Bool
    init(urlString: String?, params: [String : Any]?, uploadData: Data?, showHub: Bool, isUpload: Bool) {
        self.urlString = urlString
        self.params = params
        self.uploadData = uploadData
        self.showHub = showHub
        self.isUpload = isUpload
    }
}

// MARK: - 队列（host 为空或正在更换时暂存；按 url+参数 去重，合并回调；host 就绪后顺序执行）

class NetworkToolQueueManager {
    static let shared = NetworkToolQueueManager()

    private let stateQueue = DispatchQueue(label: "com.eventualiately.networktool.queue")
    private var orderedKeys: [String] = []
    private var batches: [String: PendingBatch] = [:]
    private var isDraining = false
    private var hostObserverInstalled = false

    private struct PendingBatch {
        var snapshot: NetworkToolSnapshot
        var handlers: [Handler]
    }

    func ensureHostObserver() {
        stateQueue.async { [weak self] in
            guard let self = self, !self.hostObserverInstalled else { return }
            self.hostObserverInstalled = true
            let previous = SwitchHostAddress.shared.onHostUpdate
            SwitchHostAddress.shared.onHostUpdate = { host in
                previous?(host)
                self.handleHostUpdate(host)
            }
        }
    }

    private func handleHostUpdate(_ host: String?) {
        stateQueue.async { [weak self] in
            guard let self = self else { return }
            if let h = host, !h.isEmpty {
                self.startDrainIfNeeded()
            } else {
                self.failAllPending()
            }
        }
    }

    func enqueue(snapshot: NetworkToolSnapshot, handler: @escaping Handler) {
        let key = Self.dedupKey(for: snapshot)
        stateQueue.async { [weak self] in
            guard let self = self else { return }
            if var existing = self.batches[key] {
                existing.handlers.append(handler)
                self.batches[key] = existing
            } else {
                self.batches[key] = PendingBatch(snapshot: snapshot, handlers: [handler])
                self.orderedKeys.append(key)
            }
            self.tryFlushIfHostReady()
        }
    }

    /// host 已就绪且未在更换时，若队列里已有任务则开始顺序执行（解决 enqueue 与 onHostUpdate 的竞态）
    private func tryFlushIfHostReady() {
        let host = SwitchHostAddress.shared.addresss()
        let switching = SwitchHostAddress.shared.isHostSwitchInProgress()
        guard !host.isEmpty, !switching, !orderedKeys.isEmpty else { return }
        startDrainIfNeeded()
    }

    private func failAllPending() {
        let msg = hx_localDoc("a54")
        let copy: [(handlers: [Handler], snapshot: NetworkToolSnapshot)] = orderedKeys.compactMap { key in
            guard let b = batches[key] else { return nil }
            return (b.handlers, b.snapshot)
        }
        orderedKeys.removeAll()
        batches.removeAll()
        isDraining = false
        for item in copy {
            for h in item.handlers {
                DispatchQueue.main.async {
                    h(-999, false, msg)
                }
            }
        }
    }

    private func startDrainIfNeeded() {
        guard !isDraining else { return }
        isDraining = true
        drainNext()
    }

    private func drainNext() {
        guard !orderedKeys.isEmpty else {
            isDraining = false
            return
        }
        let key = orderedKeys.removeFirst()
        guard let batch = batches.removeValue(forKey: key) else {
            drainNext()
            return
        }
        let handlers = batch.handlers
        let snap = batch.snapshot

        guard let request = NetworkTool.buildURLRequest(snapshot: snap) else {
            let msg = hx_commonDoc("a54")
            for h in handlers {
                DispatchQueue.main.async {
                    h(-999, false, msg)
                }
            }
            stateQueue.async { [weak self] in
                self?.drainNext()
            }
            return
        }

        if snap.showHub {
            DispatchQueue.main.async {
                LoadingIndicator.hx_show(showIndicator: true)
            }
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if snap.showHub {
                    LoadingIndicator.hx_hide()
                }
                NetworkTool.dispatchResponse(
                    data: data,
                    response: response,
                    error: error,
                    urlString: snap.urlString,
                    params: snap.params,
                    handlers: handlers
                )
            }
            self?.stateQueue.async { [weak self] in
                self?.drainNext()
            }
        }
        task.resume()
    }

    private static func dedupKey(for s: NetworkToolSnapshot) -> String {
        let path = s.urlString ?? ""
        let paramsJSON = stableJSONString(s.params)
        let uploadTag: String
        if s.isUpload, let d = s.uploadData, !d.isEmpty {
            let digest = SHA256.hash(data: d)
            uploadTag = "upload:\(digest.map { String(format: "%02x", $0) }.joined())"
        } else {
            uploadTag = "noupload"
        }
        return "\(path)|\(paramsJSON)|\(uploadTag)"
    }

    private static func stableJSONString(_ dict: [String: Any]?) -> String {
        guard let dict = dict, JSONSerialization.isValidJSONObject(dict),
              let data = try? JSONSerialization.data(withJSONObject: dict, options: [.sortedKeys]),
              let str = String(data: data, encoding: .utf8) else { return "" }
        return str
    }
}

