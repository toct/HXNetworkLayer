import Foundation

class AccountDeleteInModel: NSObject {
    func hx_execute(closer: @escaping ((Bool, String)->())) {
        NetworkTool().url(hx_accountDelete_url).params().callback({ _, success, hx_data in
            closer(success, success == false ? hx_data as? String ?? "" : "")
        }).request()
    }
}
