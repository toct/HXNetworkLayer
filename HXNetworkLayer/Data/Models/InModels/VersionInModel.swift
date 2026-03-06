import Foundation

public class VersionInModel: NSObject  {
    public func hx_execute(closer: @escaping ((VersionOutModel?) -> ())) {
        NetworkTool().url(hx_version_url).params().callback {_, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: VersionOutModel.self)
                    SharedModel.shared.hx_updateData = hx_data
                    closer(hx_data)
                }
            }
        }.request()
    }
}
