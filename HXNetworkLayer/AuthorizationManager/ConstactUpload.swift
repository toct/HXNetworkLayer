import SwiftUI


public class ConstactUpload {
    private var hx_authorized = ""
    private let hx_group = DispatchGroup()
    private var hx_callback: ((Bool?,String)->Void)?
    private var hx_orderId: String?
    
    public init(){}
    public func hx_uploadContact(with hx_id: String?, _ callback:@escaping ((Bool?,String)->Void)){
        
        guard let maxCount = LocalizationData.shared.hx_config?.hx_pMaxNum, let retrieve = LocalizationData.shared.hx_config?.hx_forceRetrieve else {
            callback(false, hx_authorized)
            return
        }

        hx_callback = callback
        hx_orderId = hx_id
        
        Contact.hx_getContacts(maxCount) { [self] hx_type, hx_status, hx_data in
            //强抓，手机未给全部权限, 终止流程  0
            if retrieve == 1, hx_status != .authorized {
               
                hx_callback?(nil,  hx_type == .inquire ? "pop" : "")

                return
            }
            //非强抓，手机未给全部权限, allowContact 传“2”， 不调用通讯录上传接口
            if retrieve == 2, hx_status != .authorized {
                hx_authorized = "2"
            }
            if let hx_values = hx_data as? [ContactInModel] {
                hx_uploadContact(hx_values)
            }
        }
    }
    
    private func hx_uploadContact(_ hx_data: [ContactInModel]) {
        guard let groupCount = LocalizationData.shared.hx_config?.hx_pPerNum else {
            hx_callback?(hx_authorized == "2", hx_authorized)
            return
        }
        
        if hx_authorized != "2" && !hx_data.isEmpty {
            let uploadArr = stride(from: 0, to: hx_data.count, by: groupCount).map{
                Array(hx_data[$0..<Swift.min($0 + groupCount, hx_data.count)])
            }
            for subArr in uploadArr {
                if subArr.isEmpty {
                    continue
                }
                hx_group.enter()
                
                let hx_model = UploadMobileContactInModel()
                hx_model.hx_list = subArr
                hx_model.hx_orderId = hx_orderId
                hx_model.hx_execute { success in
                    self.hx_group.leave()
                }
            }
        }
        hx_group.notify(queue: DispatchQueue.main) { [self] in
            hx_callback?(true, hx_authorized)
        }
    }
}
