import Foundation

class BankCardsInModel: NSObject {
    func hx_execute(closer: @escaping ((CardsOutModel?)->())) {
        NetworkTool().url(hx_bankCards_url).params().callback({_, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: CardsOutModel.self)
                    closer(hx_data)
                }
            }
        }).request()
    }
}
