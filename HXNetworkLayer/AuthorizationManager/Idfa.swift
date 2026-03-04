import Foundation
import AppTrackingTransparency
import AdSupport

class Idfa: NSObject {
    static let manager = Idfa()

    var hx_callBack: CallBackType?

    @available(iOS 14, *)
    func hx_getIdfaAuth() {
        ATTrackingManager.requestTrackingAuthorization { [weak self] status in
            if status == .authorized {
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                self?.hx_callBack?(.authorization, .authorized, idfa)
            } else {
                self?.hx_callBack?(.authorization, .restricted, "")
            }
        }
    }
        
    static func hx_checkAuth(_ closer: @escaping CallBackType) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            _ = SharedModel.shared.adjConfig
        }
                
        let hx_callback: CallBackType = { hx_type, hx_status, hx_data in
            _ = SharedModel.shared.adjConfig
            if hx_status == .authorized {
                hx_uploadBuryPoint("17")
            }else{
                hx_uploadBuryPoint("18")
            }
            _ = SharedModel.shared.adjConfig
            closer(hx_type, hx_status, hx_data)
        }
        
        let hx_data = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let hx_status = ATTrackingManager.trackingAuthorizationStatus
        switch hx_status {
        case .notDetermined:
            Idfa.manager.hx_callBack = hx_callback
            Idfa.manager.hx_getIdfaAuth()
            return
        case .authorized:
            hx_callback(.inquire, .authorized, hx_data)
        case .restricted:
            hx_callback(.inquire, .restricted, hx_data)
        case .denied:
            hx_callback(.inquire, .denied, hx_data)
        @unknown default:
            return
        }
    }
}

