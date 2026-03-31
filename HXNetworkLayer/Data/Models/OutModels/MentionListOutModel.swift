class MentionListOutModel: Codable {
    var  hx_nickName: String?
    var  hx_remark: String?
    var  hx_rate: Int?
    var  hx_uName: String?
    
    enum CodingKeys:String, CodingKey {
        case  hx_nickName = "nickName"
        case  hx_remark = "remarks"
        case  hx_rate = "starRating"
        case  hx_uName = "userName"
    }
}
