import Foundation

class KycLivenessCommitInModel: NSObject, Codable {
    var hx_liveness: String?
    enum CodingKeys: String, CodingKey {
        case hx_liveness = "liveness"
    }
    func hx_execute(closer: @escaping (() -> ())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_kycLivenessCommit_url).params(hx_dict, signedKeys: ["liveness"]).callback { _, success, hx_data in
            if success {
                closer()
            } else if let msg = hx_data as? String {
                LoadingIndicator.hx_show(msg)
            }
        }.request()
    }
}
