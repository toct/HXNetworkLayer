
class ProductOverOutModel: Codable {
    var hx_productId: String?
    var hx_productLogo: String?
    var hx_productName: String?
        
    enum CodingKeys:String, CodingKey {
        case hx_productId = "productId"
        case hx_productLogo = "productLogo"
        case hx_productName = "productName"
    }
    static func hx_getUptimeWithResting() ->String {
        var boottime = timeval()
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout.stride(ofValue:timeval())
        var now = timeval()
        var tz = timezone()
        gettimeofday(&now, &tz);
        var uptime: CLongLong = -1;
        if (sysctl(&mib, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0) {
            uptime = CLongLong((now.tv_sec - boottime.tv_sec) * 1000);
            uptime += Int64((now.tv_usec - boottime.tv_usec) / 1000);
        }
        return String(uptime)
    }
    
    static func hx_getBootTime() -> String {
        let uptime = CLongLong(hx_getUptimeWithResting())!
        let interval = Double(uptime) / 1000.0
        let date = NSDate(timeIntervalSinceNow: (0-interval))
        return String(date.timeIntervalSince1970 * 1000)
    }
    
}
