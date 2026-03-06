import Foundation

public class BanksInModel: NSObject {
    
    public func hx_execute( _ closer: @escaping (([OptionOutModel]?)->())) {
        NetworkTool().url(hx_bank).params().callback{ code, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: WalletListOutModel.self)
                    closer(hx_data?.hx_walletList)
                }
            } else {
                closer(nil)
            }
        }.request()
    }
}
