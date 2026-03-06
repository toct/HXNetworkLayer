import Foundation


typealias Handler = ((Int?, Bool, Any) ->Void)

class NetworkTool{
    private var hx_urlString: String?
    private var hx_params: [String: Any]?
    private var hx_uploadData: Data?

    private var hx_showHub:Bool = true
    private var handler: Handler?
    
    private func hx_request(_ isUploadAction: Bool) -> URLRequest? {
        guard let urlComponent = hx_urlString,
                let url = URL(string: SwitchHostAddress.shared.addresss() + urlComponent),
                let param = hx_params else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(HtmlParamModel.hx_UA(), forHTTPHeaderField: "User-Agent")
        if let uploadData = hx_uploadData, isUploadAction {
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
        }else{
            request.httpBody = try? JSONSerialization.data(withJSONObject: param as Any)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}

extension NetworkTool{
    func url(_ url: String) -> Self {
        self.hx_urlString = url
        return self
    }
    
    func params(_ params:[String: Any] = [:], signedKeys:[String] = []) -> Self {
        let paramModel = ParamInModel(param: params, needSignedKey: signedKeys)
        hx_params = paramModel.hx_getJson()
        return self
    }
    func uploadImage(_ imageData:Data?) -> Self {
        self.hx_uploadData = imageData
        return self
    }
    func hub(_ show: Bool) -> Self {
        self.hx_showHub = show
        return self
    }
    
    func callback(_ handler: @escaping Handler) -> Self {
        self.handler = handler
        return self
    }
}

extension NetworkTool{
    
    func request(_ isUpload: Bool = false) -> Void {
        guard let hx_httpResquest = hx_request(isUpload), !SharedModel.shared.hx_isForceUpdate() else { return }
        
        if hx_showHub {
            LoadingIndicator.hx_show(showIndicator: true)
        }

       let task = URLSession.shared.dataTask(with: hx_httpResquest) { data, response, error in
           DispatchQueue.main.async { [self] in
               if hx_showHub {
                   LoadingIndicator.hx_hide()
               }
               if let error = error as? URLError {
                   if let url = error.failureURLString, !url.contains(hx_buryVariable_url) && !url.contains("/app/v3/category/gory") {
                       LoadingIndicator.hx_show(hx_commonDoc("a54"))
                   }
                   let _ = SwitchHostAddress.shared.requestApiHost()
                   handler?(-999, false, hx_commonDoc("a54"))
               }else{
                   if let response = response as? HTTPURLResponse, let data = data, response.statusCode == 200 {
                       if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                           print("======\(hx_urlString!)======")
                           print(hx_params!)
                           print(jsonObject)

                           let data = JsonKit.hx_jsonToModel(jsonObject, modelType: RootOutModel.self)

                           guard let responseData = data, responseData.hx_resultCode == 200 || responseData.hx_resultCode == 6201144 else {
                               handler?(data?.hx_resultCode, false, data?.hx_resultMsg ?? "")
                               return
                           }
                           
                           if let json = jsonObject["data"] as? Dictionary<String, Any> {
                               self.handler?(responseData.hx_resultCode ,true, json)
                           } else if let jsons = jsonObject["data"] as? [Any] {
                               if let json = jsons.first as? Dictionary<String, Any> {
                                   self.handler?(responseData.hx_resultCode ,true, json)
                               }
                           } else {
                               self.handler?(responseData.hx_resultCode ,true, data?.hx_resultMsg)
                           }
                       }
                   } else {
                       print("server response data error: \(hx_urlString!)")
                       print(hx_params!)

                   }
               }
           }
       }
       task.resume()
    }
}
