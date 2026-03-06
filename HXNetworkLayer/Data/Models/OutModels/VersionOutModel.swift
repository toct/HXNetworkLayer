
public class VersionOutModel: Codable{
    public enum AppUpdateType {
        case hx_normalUpdate
        case hx_forceUpdate
    }
    public var hx_latestForceVersion: String?
    public var hx_latestForceVersionContent: String?
    public var hx_latestForceVersionUrl: String?
    public var hx_latestVersion: String?
    public var hx_latestVersionContent: String?
    public var hx_latestVersionUrl: String?
    
    public var hx_type: AppUpdateType?
    public var hx_url: URL?
    public var hx_updateVersion: String?
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_latestForceVersion = try container.decodeIfPresent(String.self, forKey: .hx_latestForceVersion)
        self.hx_latestForceVersionContent = try container.decodeIfPresent(String.self, forKey: .hx_latestForceVersionContent)
        self.hx_latestForceVersionUrl = try container.decodeIfPresent(String.self, forKey: .hx_latestForceVersionUrl)
        self.hx_latestVersion = try container.decodeIfPresent(String.self, forKey: .hx_latestVersion)
        self.hx_latestVersionContent = try container.decodeIfPresent(String.self, forKey: .hx_latestVersionContent)
        self.hx_latestVersionUrl = try container.decodeIfPresent(String.self, forKey: .hx_latestVersionUrl)
        
        hx_setupProperties()
    }
    
    enum CodingKeys:String, CodingKey {
        case hx_latestForceVersion = "latestForceVersion"
        case hx_latestForceVersionContent = "latestForceVersionContent"
        case hx_latestForceVersionUrl = "latestForceVersionUrl"
        case hx_latestVersion = "latestVersion"
        case hx_latestVersionContent = "latestVersionContent"
        case hx_latestVersionUrl = "latestVersionUrl"
    }
    
    func hx_setupProperties() {
        let hx_appVersion = DeviceInfoInModel.hx_appVersion()
        if let hx_updateV = hx_latestForceVersion, let hx_updateUrlStr = hx_latestForceVersionUrl, let hx_link = URL(string: hx_updateUrlStr),!hx_updateV.isEmpty {
            let compareResult = hx_compare(hx_appVersion, hx_updateV)
            if compareResult == .orderedAscending {
                hx_updateVersion = hx_updateV
                hx_type = .hx_forceUpdate
                self.hx_url = hx_link
                return
            }
        }
        
        if let hx_updateV = hx_latestVersion, let hx_updateUrlStr = hx_latestVersionUrl, let hx_link = URL(string: hx_updateUrlStr), !hx_updateV.isEmpty {
            
            if ViewSetting.shared.hx_normalUpdateShowed == false {
                ViewSetting.shared.hx_normalUpdateShowed = true
                let compareResult = hx_compare(hx_appVersion, hx_updateV)
                hx_updateVersion = hx_updateV
                hx_type = compareResult == .orderedAscending ? .hx_normalUpdate : nil
                self.hx_url = hx_link
            }
        }
    }
    func hx_compare(_ version1: String, _ version2: String) -> ComparisonResult {
        let hx_version1 = version1.components(separatedBy: ".")
        let hx_version2 = version2.components(separatedBy: ".")
        
        let maxLength = max(hx_version1.count, hx_version2.count)
        
        for i in 0..<maxLength {
            let v1Item = i < hx_version1.count ? hx_version1[i] : "0"
            let v2Item = i < hx_version2.count ? hx_version2[i] : "0"
            
            if let v1Value = Int(v1Item), let v2Value = Int(v2Item) {
                if v1Value < v2Value {
                    return .orderedAscending
                } else if v1Value > v2Value {
                    return .orderedDescending
                }
            }
        }
        return .orderedSame
    }
}
