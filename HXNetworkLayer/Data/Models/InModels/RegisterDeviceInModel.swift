import Foundation

class RegisterDeviceInModel: NSObject {
    var hx_deviceInfo = DeviceInfoInModel()
    func hx_execute(closer: @escaping ((Bool) -> ())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: hx_deviceInfo) else { return }
        NetworkTool().url(hx_registerDevice_url).params(hx_dict).callback { _, success, _ in
            closer(success)
        }.request()
    }
}
