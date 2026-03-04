

import Foundation
import AVFoundation

class Camera: NSObject {
    static let manager = Camera()

    var hx_callBack:CallBackType?

    func hx_getAuthority() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:{ [weak self] authorized in
            if authorized {
                self?.hx_callBack?( .authorization,.authorized, nil)
            }else{
                let hx_authStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                switch hx_authStatus {
                case .notDetermined:
                    self?.hx_callBack?(.authorization, .notDetermined, nil)
                    return
                case .authorized:
                    self?.hx_callBack?(.authorization, .authorized, nil)
                case .restricted:
                    self?.hx_callBack?(.authorization, .restricted, nil)
                case .denied:
                    self?.hx_callBack?(.authorization, .denied, nil)
                @unknown default:
                    return
                }
            }
        })
    }
        
    static func hx_checkAuth(_ closer: @escaping CallBackType) {
        let hx_callback: CallBackType = { hx_type, hx_status, hx_data in
            if hx_status == .authorized || hx_status == .limited {
                hx_uploadBuryPoint("11")
            } else {
                hx_uploadBuryPoint("12")
            }
            closer(hx_type, hx_status, hx_data)
        }
        
        let hx_status =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch hx_status {
        case .notDetermined:
            Camera.manager.hx_callBack = hx_callback
            Camera.manager.hx_getAuthority()
            return
        case .authorized:
            hx_callback(.inquire, .authorized, nil)
        case .restricted:
            hx_callback(.inquire, .restricted, nil)
        case .denied:
            hx_callback(.inquire, .denied, nil)
        @unknown default:
            return
        }
    }
}
