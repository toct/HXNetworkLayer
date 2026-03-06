import Foundation

public class ProductDIsplayInquireInModel: NSObject {
    public func hx_execute(closer: @escaping ((Bool) -> ())) {
        NetworkTool().url(hx_productDIsplayInquire_url).params().callback({_, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: HomeDataOutModel.self)
                    LocalizationData.shared.hx_homeData = hx_data
                    closer(success)
                }
            }else{
                closer(success)
            }
        }).request()
    }
}
