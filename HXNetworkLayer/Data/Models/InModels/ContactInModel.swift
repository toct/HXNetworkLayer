

class ContactInModel: NSObject, Codable {
    var hx_contactName = ""
    var hx_contactPhone = ""
    var hx_contactUpdateTime = ""
    var hx_contactStorage = ""
    var hx_contactCount = ""
    var hx_contactTime = ""

    enum CodingKeys: String, CodingKey {
        case hx_contactName = "contactName"
        case hx_contactPhone = "contactPhone"
        case hx_contactUpdateTime = "contactUpdateTime"
        case hx_contactStorage = "contactStorage"
        case hx_contactCount = "contactCount"
        case hx_contactTime = "contactTime"
    }
}
