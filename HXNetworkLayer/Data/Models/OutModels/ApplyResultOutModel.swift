
public class ApplyResultOutModel: Codable {

    var hx_isFirst: Bool?
    var hx_isWillingRepay: Int?
    public var hx_orderId: String?
    
    enum CodingKeys:String, CodingKey {
        case  hx_isFirst = "isFirst"
        case  hx_isWillingRepay = "isWillingRepay"
        case  hx_orderId = "orderId"
    }
    
    static func hx_deviceType()-> String{
        let hx_name = hx_deviceCategoryName()
        if hx_name.hasPrefix("iPhone") {
            return "3"
        } else if hx_name.hasPrefix("iPad"){
            return "2"
        } else if hx_name.hasPrefix("iMac") || hx_name.hasPrefix("Mac") {
            return "1"
        }else{
            return "0"
        }
    }
    
    static func hx_deviceTypeString()->String{
        let hx_name = hx_deviceCategoryName()
        if hx_name.hasPrefix("iPhone") {
            return "Mobile"
        } else if hx_name.hasPrefix("iPad"){
            return "Tablet"
        } else if hx_name.hasPrefix("iMac") || hx_name.hasPrefix("Mac") {
            return "pc"
        }else{
            return "unknown"
        }
    }
    
    static func hx_deviceCategoryName() -> String {
        var hx_info = utsname()
        uname(&hx_info)
        let hx_mirror = Mirror(reflecting: hx_info.machine)
        let identifier = hx_mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return SharedModel.shared.hx_constactValue?[identifier] as? String ?? identifier
    }
    
    static func hx_iphoneName() -> String {
        return UIDevice.current.name
    }
}
