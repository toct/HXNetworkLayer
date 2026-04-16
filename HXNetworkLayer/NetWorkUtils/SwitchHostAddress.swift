import Foundation

class SwitchHostAddress {
    static let shared = SwitchHostAddress()
    
    // 回调：host更新时调用
    var onHostUpdate: ((String?) -> Void)?
    
    // 串行队列，保证所有操作顺序执行
    private let serialQueue = DispatchQueue(label: "com.switchHost.serial")
    
    // 状态标记
    private var isFetching = false
    private var cachedHost: String = ""
    /// 当前正在更换 host 时，若有新的更换请求则合并为「下一轮」；本轮结束后由 scheduleNextRoundIfNeeded 处理
    private var pendingNextRound = false
    
    /// 本轮更换开始时快照的 host 入口 URL 列表，按序轮询
    private var roundHostsSnapshot: [String] = []
    /// 当前尝试在 roundHostsSnapshot 中的下标
    private var roundHostIndex: Int = 0
    
    // 原有属性
    private let hx_hostAddress = "hostAddress"
    
    // hosts 数组
    private var hosts: [String] {
        return SharedModel.shared.hx_constactValue?[hostPrefix] as? [String] ?? []
    }
    
    private init() {
        // 从 UserDefaults 读取缓存的 host
        if let address = UserDefaults.standard.string(forKey: hx_hostAddress) {
            cachedHost = address
        }
        
        
        // 如果没有缓存，自动获取
        if cachedHost.isEmpty {
            requestApiHost()
        }
    }
    
    /// 是否正在拉取/更换 host（供 NetworkTool 请求队列判断）
    func isHostSwitchInProgress() -> Bool {
        serialQueue.sync { isFetching }
    }
    
    /// 对外接口：请求获取 host
    /// - Parameter force: 是否强制刷新，忽略缓存
    func requestApiHost(force: Bool = false) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            
            // 有缓存且不强制刷新，直接回调（无需进入更换流程）
            if !force && !self.cachedHost.isEmpty {
                DispatchQueue.main.async {
                    print("✅ 使用缓存 host: \(self.cachedHost)")
                    self.onHostUpdate?(self.cachedHost)
                }
                return
            }
            
            // 正在更换中：不丢弃，合并为「下一轮」等待
            if self.isFetching {
                self.pendingNextRound = true
                print("⏳ 正在更换 host，已排队等待本轮结束后再处理")
                return
            }
            
            // 开始本轮更换
            print("🔄 开始更换 host（将按序尝试 \(self.hosts.count) 个入口）")
            self.isFetching = true
            self.fetchFirstHost()
        }
    }
    
    /// 开始一轮：快照 hosts，从第一个入口依次请求
    private func fetchFirstHost() {
        dispatchPrecondition(condition: .onQueue(serialQueue))
        
        let list = hosts
        guard !list.isEmpty else {
            print("❌ 没有可用的 host 列表")
            completeRoundWithFailure()
            return
        }
        
        roundHostsSnapshot = list
        roundHostIndex = 0
        tryHostAtCurrentIndex()
    }
    
    /// 尝试当前下标对应的入口 URL
    private func tryHostAtCurrentIndex() {
        dispatchPrecondition(condition: .onQueue(serialQueue))
        
        guard roundHostIndex < roundHostsSnapshot.count else {
            completeRoundWithFailure()
            return
        }
        
        let urlString = roundHostsSnapshot[roundHostIndex]
        let total = roundHostsSnapshot.count
        let idx = roundHostIndex + 1
        print("🌐 尝试 host 入口 [\(idx)/\(total)]: \(urlString)")
        fetchHostFromUrl(urlString)
    }
    
    /// 单次请求失败（网络、解析失败、URL 无效等）：尝试下一个入口；已全部尝试则本轮失败
    private func advanceAfterAttemptFailure() {
        dispatchPrecondition(condition: .onQueue(serialQueue))
        
        roundHostIndex += 1
        if roundHostIndex < roundHostsSnapshot.count {
            tryHostAtCurrentIndex()
        } else {
            print("❌ 全部 \(roundHostsSnapshot.count) 个 host 入口均已尝试，未能获取有效 host")
            completeRoundWithFailure()
        }
    }
    
    /// 从指定 URL 获取 host
    private func fetchHostFromUrl(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("❌ URL 无效: \(urlString)")
            serialQueue.async { [weak self] in
                self?.advanceAfterAttemptFailure()
            }
            return
        }
        
        // 显示加载提示
        DispatchQueue.main.async {
            LoadingIndicator.hx_show()
        }
        
        // 配置请求
        let configure = URLSessionConfiguration.default
        configure.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(configuration: configure)
        
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            // 隐藏加载提示
            DispatchQueue.main.async {
                LoadingIndicator.hx_hide()
            }
            
            guard let self = self else { return }
            
            // 处理响应
            if let data = data, error == nil,
               let content = String(data: data, encoding: .utf8), !content.isEmpty {
                
                // 解析分隔符（保持原有逻辑）
                var separator = "ba2f7f"
                if !hostPrefix.contains("test") {
                    separator = "pa2f7t"
                }
                
                if let hostSuffix = content.components(separatedBy: separator).dropFirst().first {
                    let finalHost = hostPrefix + hostSuffix
                    self.handleSuccess(finalHost)
                    return
                } else {
                    print("⚠️ 解析失败，分隔符未找到: \(separator)")
                    print("响应内容: \(content)")
                }
            } else {
                print("⚠️ 请求失败: \(urlString), error: \(error?.localizedDescription ?? "unknown")")
            }
            
            // 本次入口失败，尝试下一个
            self.serialQueue.async { [weak self] in
                self?.advanceAfterAttemptFailure()
            }
        }
        
        task.resume()
    }
    
    /// 处理成功
    private func handleSuccess(_ host: String) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.cachedHost = host
            self.isFetching = false
            self.roundHostsSnapshot = []
            self.roundHostIndex = 0
            
            // 保存到 UserDefaults
            UserDefaults.standard.setValue(host, forKey: self.hx_hostAddress)
            UserDefaults.standard.synchronize()
            
            print("✅ 成功获取 host: \(host)")
            
            // 更换过程中若有排队，此时已拿到 host，无需再发起一轮请求；合并为同一次成功回调即可
            if self.pendingNextRound {
                self.pendingNextRound = false
            }
            
            DispatchQueue.main.async {
                self.onHostUpdate?(host)
            }
        }
    }
    
    /// 本轮内所有入口均失败后的收尾
    private func completeRoundWithFailure() {
        dispatchPrecondition(condition: .onQueue(serialQueue))
        
        roundHostsSnapshot = []
        roundHostIndex = 0
        isFetching = false
        
        DispatchQueue.main.async {
            LoadingIndicator.hx_show(hx_localDoc("a54"))
            self.onHostUpdate?(nil)
        }
        
        scheduleNextRoundIfNeeded()
    }
    
    /// 本轮结束后：若曾有「等待下一轮」的请求，则立即开始下一轮更换
    private func scheduleNextRoundIfNeeded() {
        dispatchPrecondition(condition: .onQueue(serialQueue))
        guard pendingNextRound else { return }
        pendingNextRound = false
        print("🔄 上一轮已结束，开始下一轮更换 host")
        isFetching = true
        fetchFirstHost()
    }
    
    /// 重置排队标记（例如网络恢复后手动清理）
    func resetTryState() {
        serialQueue.async { [weak self] in
            self?.pendingNextRound = false
            print("🔄 已清除等待下一轮的标记")
        }
    }
    
    /// 获取当前 host（同步方法）
    func currentHost() -> String {
        return cachedHost
    }
    
    /// 原有方法，保持兼容
    func addresss() -> String {
        return cachedHost
    }
}
