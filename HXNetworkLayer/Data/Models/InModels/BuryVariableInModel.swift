import Foundation

class BuryVariableInModel: NSObject, Codable {
    var hx_eventCode: String?
    var hx_eventContent: String? = "null"
    var hx_remark1: String?
    var hx_remark2: String? = "NULL"
    var hx_remark3: String? = "NULL"
    enum CodingKeys: String, CodingKey {
        case hx_eventCode = "eventCode"
        case hx_eventContent = "eventContent"
        case hx_remark1 = "remark1"
        case hx_remark2 = "remark2"
        case hx_remark3 = "remark3"
    }
    func hx_execute(hideIndicator: Bool = false, closer: ((Bool, Any)->())? = nil) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        let signedKeys = ["eventCode","eventContent","remark1","remark2","remark3"]
        NetworkTool().url(hx_buryVariable_url).params(hx_dict, signedKeys: signedKeys).hub(hideIndicator).callback({_, _, _ in
        }).request()
    }
}
func hx_uploadBuryPoint(_ code: String, remark1: String = "NULL") {
    let hx_model = BuryVariableInModel()
    hx_model.hx_eventCode = code
    hx_model.hx_remark1 = remark1
    hx_model.hx_execute()
}
