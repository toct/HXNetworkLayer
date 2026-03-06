

extension DeviceInfoInModel{
    public static let KEYCHAIN_UUID = Bundle.main.bundleIdentifier ?? "Bundle.main.bundleIdentifier"

    static func hx_systemVersion() -> String {
        var hx_version = ""
        if UIDevice.current.responds(to: #selector(getter: UIDevice.systemVersion)) {
            hx_version = UIDevice.current.systemVersion
        }
        return hx_version
    }
    
    static func hx_charging() -> String {
        let hx_device = UIDevice.current
        hx_device.isBatteryMonitoringEnabled = true
        if hx_device.batteryState == .charging || hx_device.batteryState == .full {
            return "true"
        } else {
            return "false"
        }
    }
    
    static func hx_batteryLevel() -> String {
        let hx_device = UIDevice.current
        hx_device.isBatteryMonitoringEnabled = true
        var hx_level = 0.0;
        let hx_currentLevel = hx_device.batteryLevel
        if hx_currentLevel > 0.0 {
            hx_level = Double(hx_currentLevel * 100.0);
        } else {
            return "-1";
        }
        return String(format: "%f" ,hx_level);
    }
    
    public static func hx_appName() -> String {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "สุขภาพเครดิต"
    }
    
    static func hx_appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    static func hx_getScreenResolution() -> String {
        let hx_scale = UIScreen.main.scale
        let hx_width = Int(UIScreen.main.bounds.width * hx_scale)
        let hx_height = Int(UIScreen.main.bounds.height * hx_scale)
        return "\(hx_width)-\(hx_height)"
    }
    
    static func hx_CUPCount() -> String {
        var hx_count: UInt = UInt(0)
        var len: size_t = MemoryLayout.size(ofValue: hx_count)
        sysctlbyname("hw.ncpu", &hx_count, &len, nil, 0)
        return String(hx_count)
    }
    
    static func hx_getLanguage() -> String {
        let language = Locale.preferredLanguages.first ?? ""
        if language.isEmpty {
            return language
        }
        return language.components(separatedBy: "-").first ?? ""
    }

    static func hx_getScreenBrightness() -> String {
        let brightness = UIScreen.main.brightness
        if brightness < 0.0 || brightness > 1.0 {
            return "-1"
        }
        return String(brightness * 100)
    }
    

    

    static func hx_isJailbroken() -> String
    {
        guard let paths = SharedModel.shared.hx_constactValue?["jailFiles"] as? [String] else { return "false" }
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return "true"
            }
        }
        return "false"
    }
}
