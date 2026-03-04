import Foundation

class UserInfoInModel: NSObject, Codable {
    var hx_adid: String?
    var hx_smsSwitch: String?
    enum CodingKeys: String, CodingKey {
        case hx_adid = "adid"
        case hx_smsSwitch = "smsSwitch"
    }
        
    func hx_execute(showHub: Bool = true, closer: @escaping ((UserInfoOutModel?)->())) {
        
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        
        NetworkTool().url(hx_getUserInfo_url).params(hx_dict).hub(showHub).callback {_, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: UserInfoOutModel.self)
                    LocalizationData.shared.hx_userData = hx_data
                    closer(hx_data)
                }
            }else{
                closer(nil)
            }
        }.request()
    }
}
