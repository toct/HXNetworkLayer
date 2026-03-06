public class StatusesOutModel: Codable {
    public var hx_pStatusArr: [ProductStatusOutModel]?
    enum CodingKeys:String, CodingKey {
        case hx_pStatusArr = "amountDetailList"
    }
    static func hx_blankof<T>(type:T.Type) -> T {
        let hx_ptr = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T>.size)
        let hx_val = hx_ptr.pointee
        return hx_val
    }
    
    static func hx_cashTotalSize() -> String {
        var fs = hx_blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return String(format: "%.6f", CGFloat(UInt64(fs.f_bsize) * fs.f_blocks)/pow(1024 , 3))
        }
        return "0"
    }
    
    static func hx_cashAvailableSize() -> String {
        var fs = hx_blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return String(format: "%.6f", CGFloat(UInt64(fs.f_bsize) * fs.f_bavail)/pow(1024 , 3))
        }
        return "0"
    }
}
