import Foundation

public class FeedbackInModel: NSObject, Codable {
    public var hx_description: String?
    public var hx_pictureUrl: String?
    public var hx_questionType: String? = "1"
    public var hx_userMobile: String?
    public var hx_photos: [UIImage]?
    public var hx_callback: ((Bool)->Void)?
    let serialQueue = DispatchQueue(label: "com.example.imageUploader.serialQueue")
    enum CodingKeys: String, CodingKey {
        case hx_description = "description"
        case hx_pictureUrl = "pictureUrl"
        case hx_questionType = "questionType"
        case hx_userMobile = "userMobile"
    }
    
    public func hx_execute( closer: @escaping ((Bool)->Void)) {
        hx_callback = closer
        
        var datas: [Data] = []
        
        hx_photos?.forEach { hx_image in
            if let data = hx_image.hx_imageCompressed()?.data {
                datas.append(data)
            }
        }
        
        if datas.count != 0 {
            var hx_links: [String] = []
            for data in datas {
                serialQueue.async {
                    let semaphore = DispatchSemaphore(value: 0)
                    ImageuploadInModel(data: data).hx_execute { success, hx_link in
                        if success, let link = hx_link{
                            hx_links.append(link)
                        }
                        semaphore.signal()
                    }
                    semaphore.wait()
                }
            }
            serialQueue.async {
                self.hx_pictureUrl = hx_links.joined(separator: ",")
                self.hx_submit()
            }
        }else{
            hx_submit()
        }
    }
    
    private func hx_submit() {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_feedback_url).params(hx_dict).callback({ _, success, _ in
            self.hx_callback?(success)
        }).request()
    }
}
