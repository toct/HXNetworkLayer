
class TermDetailOutModel: Codable {
    var  hx_expirDate: String?
    var  hx_interestAm: String?
    var  hx_principalAm: String?
    var  hx_repayAm: String?
    
    enum CodingKeys:String, CodingKey {
        case  hx_expirDate = "expirationDate"
        case  hx_interestAm = "interestAmountDue"
        case  hx_principalAm = "principalAmountDue"
        case  hx_repayAm = "repaymentAmount"
    }
//    ["Due Date","Amount Due","Principal Due","Interest Due"]
    static func hx_titleModel() -> TermDetailOutModel {
        let hx_model = TermDetailOutModel()
        hx_model.hx_expirDate = hx_commonDoc("p15")
        hx_model.hx_interestAm = hx_commonDoc("p34")
        hx_model.hx_principalAm = hx_commonDoc("p33")
        hx_model.hx_repayAm = hx_commonDoc("p23")
        return hx_model
    }
}
