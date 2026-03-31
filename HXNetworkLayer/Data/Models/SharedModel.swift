import AdjustSigSdk
import AdjustSdk
import Network
import CoreTelephony
import CryptoKit
import CommonCrypto

public class SharedModel: NSObject
{
    private let hx_monitor = NWPathMonitor()

    public let hx_debounce = Debouncer(delay: 0.5)

    public static let shared = SharedModel()
            
    public var hx_updateData: VersionOutModel?
        
    public var  hx_kyc:KYCSOutModel?
        
    public lazy var adjConfig: ADJConfig? = {
        let adj = ADJConfig(appToken: "pma67gx28zk0", environment: ADJEnvironmentProduction, suppressLogLevel: true)
        adj?.logLevel = ADJLogLevel.verbose
        Adjust.initSdk(adj)
        return adj
    }()
    
    public override init() {
        super.init()
        startMonitoring()
    }
    
    private func startMonitoring() {
        hx_monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                Idfa.hx_checkAuth { _, _, _ in}
                AppConfigInModel().hx_execute {}
            }
            if path.usesInterfaceType(.wifi) {
                hx_networkType = "1"
            } else if path.usesInterfaceType(.cellular) {
                
                if let dict = CTTelephonyNetworkInfo().serviceCurrentRadioAccessTechnology,
                      let firstKey = dict.keys.first,
                      let carrierTypeName = dict[firstKey] {
                    hx_networkType = SharedModel.shared.hx_constactValue?[carrierTypeName] as? String ?? "0"
                } else {
                    hx_networkType = "0"
                }
            } else {
                hx_networkType = "0"
            }
        }
        hx_monitor.start(queue: DispatchQueue.global())
    }

    public lazy var hx_constactValue: [String:Any]? = {
        do {
            let hx_name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            guard let hx_url = Bundle.main.url(forResource: hx_name, withExtension: "data") else { return nil}
            let hx_data = try Data(contentsOf: hx_url)
            let hx_keyData = Data(hx_secretKey.utf8)
            let hx_hash = SHA256.hash(data: hx_keyData)
            let hx_encryptionKey = SymmetricKey(data: Data(hx_hash))
            let sealedBox = try AES.GCM.SealedBox(combined: hx_data)
            let decryptData = try AES.GCM.open(sealedBox, using: hx_encryptionKey)
            let dictionary = try JSONSerialization.jsonObject(with: decryptData, options: []) as? [String: Any]
            return dictionary
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }()
        
    public func hx_isForceUpdate() -> Bool {
        return hx_updateData?.hx_type == .hx_forceUpdate
    }
        
    public static func hx_submitAdid() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            Adjust.adid { adidStr in
                if let adid = adidStr {
                    let hx_model = UserInfoInModel()
                    hx_model.hx_adid = adid
                    hx_model.hx_execute(showHub: false) { _ in
                    }
                }
            }
        }
    }
    
    deinit {
        hx_monitor.cancel()
    }
}
