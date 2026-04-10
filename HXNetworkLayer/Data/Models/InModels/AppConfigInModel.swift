import Foundation

public class AppConfigInModel: NSObject {
    public func hx_execute(callback: @escaping (() -> ())) {
        NetworkTool().url(hx_getAppConfig_rul).params().hub(false).callback({_, success, hx_data in
            if success {
                let hx_data = JsonKit.hx_jsonToModel(hx_data, modelType: ConfigInfoOutModel.self)
                LocalizationData.shared.hx_config = hx_data
                callback()
            }
        }).request()
    }
}
