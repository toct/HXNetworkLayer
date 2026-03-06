import Foundation

public class UploadDeviceInfoInModel: NSObject {
    public var hx_deviceInfo = DeviceInfoInModel()
    
    public func hx_execute( closer: @escaping ((Bool)->())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: hx_deviceInfo) else { return }
        NetworkTool().url(hx_uploadDeviceInfo_url).params(hx_dict, signedKeys: ["orderId"]).callback {_, success, _ in
            closer(success)
        }.request()
    }
}
