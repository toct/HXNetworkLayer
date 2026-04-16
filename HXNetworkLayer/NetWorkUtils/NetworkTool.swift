
import Foundation
import CryptoKit

public typealias Handler = ((Int?, Bool, Any) -> Void)
// MARK: - NetworkTool

public class NetworkTool {
    private var hx_urlString: String?
    private var hx_params: [String: Any]?
    private var hx_uploadData: Data?

    private var hx_showHub: Bool = true
    private var handler: Handler?

    static func buildURLRequest(snapshot s: NetworkToolSnapshot) -> URLRequest? {
        let host = SwitchHostAddress.shared.addresss()
        guard let urlComponent = s.urlString,
              let url = URL(string: host + urlComponent),
              let param = s.params, !host.isEmpty else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(HtmlParamModel.hx_UA(), forHTTPHeaderField: "User-Agent")
        if let uploadData = s.uploadData, s.isUpload {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var hx_requestBody = Data()

            for (key, value) in param {
                hx_requestBody.append("--\(boundary)\r\n".data(using: .utf8)!)
                hx_requestBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                hx_requestBody.append("\(value)\r\n".data(using: .utf8)!)
            }

            hx_requestBody.append("--\(boundary)\r\n".data(using: .utf8)!)

            hx_requestBody.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            hx_requestBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            hx_requestBody.append(uploadData)
            hx_requestBody.append("\r\n".data(using: .utf8)!)

            hx_requestBody.append("--\(boundary)--\r\n".data(using: .utf8)!)

            request.httpBody = hx_requestBody
        } else {
            request.httpBody = try? JSONSerialization.data(withJSONObject: param as Any)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }

    private func hx_request(_ isUploadAction: Bool) -> URLRequest? {
        let snap = NetworkToolSnapshot(
            urlString: hx_urlString,
            params: hx_params,
            uploadData: hx_uploadData,
            showHub: hx_showHub,
            isUpload: isUploadAction
        )
        return Self.buildURLRequest(snapshot: snap)
    }

    static func dispatchResponse(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        urlString: String?,
        params: [String: Any]?,
        handlers: [Handler]
    ) {
        if let error = error as? URLError {
            if let url = error.failureURLString, !url.contains(hx_buryVariable_url) && !url.contains("/app/v3/category/gory") {
                LoadingIndicator.hx_show(hx_commonDoc("a54"))
            }
            let _ = SwitchHostAddress.shared.requestApiHost()
            for h in handlers {
                h(-999, false, hx_commonDoc("a54"))
            }
            return
        }

        if let response = response as? HTTPURLResponse, let data = data, response.statusCode == 200 {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let us = urlString { print("======\(us)======") }
                if let ps = params { print(ps) }
                print(jsonObject)

                let parsed = JsonKit.hx_jsonToModel(jsonObject, modelType: RootOutModel.self)

                guard let responseData = parsed, responseData.hx_resultCode == 200 || responseData.hx_resultCode == 6201144 else {
                    for h in handlers {
                        h(parsed?.hx_resultCode, false, parsed?.hx_resultMsg ?? "")
                    }
                    return
                }

                if let json = jsonObject["data"] as? [String: Any] {
                    for h in handlers {
                        h(responseData.hx_resultCode, true, json)
                    }
                } else if let jsons = jsonObject["data"] as? [Any] {
                    if let json = jsons.first as? [String: Any] {
                        for h in handlers {
                            h(responseData.hx_resultCode, true, json)
                        }
                    }
                } else {
                    for h in handlers {
                        h(responseData.hx_resultCode, true, parsed?.hx_resultMsg ?? "")
                    }
                }
            }
        } else {
            if let us = urlString { print("server response data error: \(us)") }
            if let ps = params { print(ps) }
        }
    }
}

extension NetworkTool {
    public func url(_ url: String) -> Self {
        self.hx_urlString = url
        return self
    }

    public func params(_ params: [String: Any] = [:], signedKeys: [String] = []) -> Self {
        let paramModel = ParamInModel(param: params, needSignedKey: signedKeys)
        hx_params = paramModel.hx_getJson()
        return self
    }

    public func uploadImage(_ imageData: Data?) -> Self {
        self.hx_uploadData = imageData
        return self
    }

    public func hub(_ show: Bool) -> Self {
        self.hx_showHub = show
        return self
    }

    public func callback(_ handler: @escaping Handler) -> Self {
        self.handler = handler
        return self
    }
}

extension NetworkTool {

    public func request(_ isUpload: Bool = false) {
        NetworkToolQueueManager.shared.ensureHostObserver()
        guard !SharedModel.shared.hx_isForceUpdate() else { return }

        let host = SwitchHostAddress.shared.addresss()
        let switching = SwitchHostAddress.shared.isHostSwitchInProgress()

        if switching || host.isEmpty {
            guard let h = handler else { return }
            let snap = NetworkToolSnapshot(
                urlString: hx_urlString,
                params: hx_params,
                uploadData: hx_uploadData,
                showHub: hx_showHub,
                isUpload: isUpload
            )
            NetworkToolQueueManager.shared.enqueue(snapshot: snap, handler: h)
            if host.isEmpty {
                SwitchHostAddress.shared.requestApiHost()
            }
            return
        }

        guard let hx_httpRequest = hx_request(isUpload) else {
            guard let h = handler else { return }
            let snap = NetworkToolSnapshot(
                urlString: hx_urlString,
                params: hx_params,
                uploadData: hx_uploadData,
                showHub: hx_showHub,
                isUpload: isUpload
            )
            NetworkToolQueueManager.shared.enqueue(snapshot: snap, handler: h)
            SwitchHostAddress.shared.requestApiHost()
            return
        }

        if hx_showHub {
            LoadingIndicator.hx_show(showIndicator: true, timeout: nil)
        }

        let urlStr = hx_urlString
        let paramSnap = hx_params

        let task = URLSession.shared.dataTask(with: hx_httpRequest) { data, response, error in
            DispatchQueue.main.async {
                if self.hx_showHub {
                    LoadingIndicator.hx_hide()
                }
                guard let h = self.handler else { return }
                NetworkTool.dispatchResponse(
                    data: data,
                    response: response,
                    error: error,
                    urlString: urlStr,
                    params: paramSnap,
                    handlers: [h]
                )
            }
        }
        task.resume()
    }
}
