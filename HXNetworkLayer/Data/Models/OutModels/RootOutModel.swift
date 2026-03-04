import SwiftUI

class RootOutModel: Codable {
    var hx_resultCode: Int?
    var hx_resultMsg: String?
    var hx_timestamp: Int?
    private var aaresultCode: Int?
    private var aaresultMsg: String?
    private var aatimestamp: Int?

    private enum CodingKeys:String, CodingKey {
        case hx_resultCode = "resultCode", hx_resultMsg = "resultMsg", hx_timestamp = "timestamp", aaresultCode, aaresultMsg, aatimestamp
    }
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_resultCode = try container.decodeIfPresent(Int.self, forKey: .hx_resultCode) ?? container.decodeIfPresent(Int.self, forKey: .aaresultCode)
        self.hx_resultMsg = try container.decodeIfPresent(String.self, forKey: .hx_resultMsg) ?? container.decodeIfPresent(String.self, forKey: .aaresultMsg)
        self.hx_timestamp = try container.decodeIfPresent(Int.self, forKey: .hx_timestamp) ?? container.decodeIfPresent(Int.self, forKey: .aatimestamp)

        hx_setupProperties()
    }
    func hx_setupProperties() {
        if let code = hx_resultCode {
            switch code {
            case 200, 6201144:
                break
            case 2000001, 2000002, 2002001:
                if  LocalizationData.shared.hx_loginData.isLogin() {
                    SharedModel.shared.hx_debounce.debounce {
                        LoadingIndicator.hx_show(hx_commonDoc(String(code)))
                        LocalizationData.shared.hx_loginData = LoginOutModel()
                    }
                }
            case 2009006:
                SharedModel.shared.hx_debounce.debounce {
                    ViewSetting.shared.hx_updateType = "force"
                }
            case 1000000, 6202001, 6202004, 6230002, 6230003, 6230004:
                break
            default:
                LoadingIndicator.hx_show(hx_resultMsg ?? "")
            }
        }
    }
}
