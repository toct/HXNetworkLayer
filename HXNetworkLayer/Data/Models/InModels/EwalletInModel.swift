import Foundation

class EwalletInModel: NSObject, Codable {
    
    func hx_execute(hx_backType: String, _ closer: @escaping (([OptionOutModel]?)->())) {
        let hx_url = hx_backType == "E-wallet" ? hx_ewallet : hx_bank
        
        NetworkTool().url(hx_url).params().callback{ code, success, data in
            if success {
                if let hx_dict = data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: WalletListOutModel.self)
                    closer(hx_data?.hx_walletList)
                }
            } else {
                closer(nil)
            }
        }.request()
    }
}
