import Foundation

class ImageuploadInModel: NSObject {
    let hx_data: Data?
    init(data: Data?) {
        self.hx_data = data
    }
    func hx_execute(closer: @escaping ((Bool, String?)->Void)) {
        NetworkTool().url(hx_imageupload_url).params().uploadImage(hx_data).callback({ _, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any>, let imageurl = hx_dict["src"] as? String {
                    closer(success,imageurl)
                }
            }else{
                closer(false,nil)
            }
        }).request(true)
    }
}
