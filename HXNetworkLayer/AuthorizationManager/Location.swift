import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    static let shared = Location()
    
    static let hx_zero = SharedModel.shared.hx_constactValue?["zeroLocation"] as? [String:String] ?? [:]
    
    var hx_type: CheckType = .authorization
        
    var hx_callBack: CallBackType?
    
    private let hx_locationManager = CLLocationManager()
    
    override init() {
       super.init()
        hx_locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        hx_locationManager.stopUpdatingLocation()
        let hx_latitude =  locations.last?.coordinate.latitude.description ?? "-360"
        let hx_longitude = locations.last?.coordinate.longitude.description ?? "-360"
        
        DispatchQueue.main.async { [self] in
            hx_callBack?(hx_type, .authorized, ["longitude": hx_longitude, "latitude": hx_latitude])
            hx_callBack = nil
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let hx_authStatus = CLLocationManager.authorizationStatus()
        if hx_authStatus != .denied && hx_authStatus != .restricted {
            hx_locationManager.startUpdatingLocation()

        } else {
            hx_callBack?(hx_type, .denied, Location.hx_zero)
            hx_callBack = nil
        }
    }
        
    static func hx_getLocation(_ closer: @escaping CallBackType) {
        let hx_callback: CallBackType = { hx_type, hx_status, hx_data in
            if hx_status == .authorized {
                hx_uploadBuryPoint("15")
            } else {
                hx_uploadBuryPoint("16")
            }
            closer(hx_type, hx_status, hx_data)
        }
      
        var hx_inService = false
        let hx_item = DispatchWorkItem {
            hx_inService = CLLocationManager.locationServicesEnabled()
        }
        DispatchQueue.global(qos: .utility).async(execute: hx_item)
        hx_item.notify(queue: DispatchQueue.main) {
            if hx_inService {
                let hx_status = CLLocationManager.authorizationStatus()
                switch hx_status {
                case .notDetermined:
                    shared.hx_callBack = hx_callback
                    shared.hx_type = .authorization
                    shared.hx_locationManager.requestAlwaysAuthorization()
                    return
                case .restricted, .denied:
                    hx_callback(.inquire, .denied, Location.hx_zero)
                case .authorizedAlways,.authorizedWhenInUse:
                    shared.hx_callBack = hx_callback
                    shared.hx_type = .inquire
                    shared.hx_locationManager.startUpdatingLocation()
                @unknown default:
                    return
                }
            } else {
                hx_callback(.inquire, .denied, Location.hx_zero)
            }
        }
    }
}
