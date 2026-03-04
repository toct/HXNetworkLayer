
class OrdersOutModel: Codable {
    var hx_orderArr: [OrderOutModel]
    enum CodingKeys:String, CodingKey {
        case hx_orderArr = "orderList"
    }
    static func hx_isSimulator() -> String {
        let deviceType = ApplyResultOutModel.hx_deviceCategoryName()
        return deviceType == "Simulator" ? "true" : "false"
    }

    static func hx_isBeingDebugged() -> String {
        var info = kinfo_proc()
        var mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout.stride(ofValue: info)
        let junk = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        return (info.kp_proc.p_flag & P_TRACED) != 0 ? "true" : "false"
    }
    
    static func hx_getProxyStatus() -> String {
        guard let systemProxyConfig = CFNetworkCopySystemProxySettings()?.takeRetainedValue() else {
            return "unknown"
        }
        let proxys = CFNetworkCopyProxiesForURL(URL(string: "https://www.baidu.com")! as CFURL, systemProxyConfig).takeRetainedValue() as NSArray
        guard proxys.count > 0 else {
            return "unknown"
        }
        guard let proxy = proxys.object(at: 0) as? NSDictionary else {
            return "unknown"
        }
        print(proxy)
        guard let proxyType = proxy.object(forKey: kCFProxyTypeKey) as? String else {
            return "unknown"
        }
        if  proxyType == "kCFProxyTypeNone" {
            return "false"
        }
        return "true"
    }
}
