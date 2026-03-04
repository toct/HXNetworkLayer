import Foundation

class HomeDataOutModel: Codable, Identifiable{
    let id = UUID()
    var hx_loanOpt: String?
    var hx_hasOrder: Int?
    var hx_headerPrompt: String?
    var hx_userStatus: Int?
    var hx_userType:Int?
    var hx_payDay: String?
    var hx_incomeAmountMonthly:String?
    var hx_drawalId:String?
    private var hx_loanRecord:[String]?
    var hx_record:[String] = []
    var hx_autoTakeOrder = false
    var hx_clickable = false
    enum CodingKeys:String, CodingKey {
        case hx_loanOpt = "firstLoanOptionLine"
        case hx_hasOrder = "hasOrder"
        case hx_headerPrompt = "promptCopy"
        case hx_userStatus = "userStatus"
        case hx_userType = "appUserType"
        case hx_loanRecord = "loanSuccessRecordList"
        case hx_payDay = "payDay"
        case hx_incomeAmountMonthly = "incomeAmountMonthly"
        case hx_drawalId = "withdrawalOrderId"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_loanOpt = try container.decodeIfPresent(String.self, forKey: .hx_loanOpt)
        self.hx_hasOrder = try container.decodeIfPresent(Int.self, forKey: .hx_hasOrder)
        self.hx_headerPrompt = try container.decodeIfPresent(String.self, forKey: .hx_headerPrompt)
        self.hx_userStatus = try container.decodeIfPresent(Int.self, forKey: .hx_userStatus)
        self.hx_userType = try container.decodeIfPresent(Int.self, forKey: .hx_userType)
        self.hx_loanRecord = try container.decodeIfPresent([String].self, forKey: .hx_loanRecord)
        self.hx_payDay = try container.decodeIfPresent(String.self, forKey: .hx_payDay)
        self.hx_incomeAmountMonthly = try container.decodeIfPresent(String.self, forKey: .hx_incomeAmountMonthly)
        self.hx_drawalId = try container.decodeIfPresent(String.self, forKey: .hx_drawalId)
        hx_setupProperties()
    }
    
    func hx_setupProperties() {
        if let hasOrder = hx_hasOrder, let status = hx_userStatus, let firstLoan = hx_loanOpt, hasOrder == 0, status == 20, firstLoan == "system" {
            hx_autoTakeOrder = true
        }
        if let status = hx_userStatus {
            hx_clickable = [10,30,32,41,80,81].contains(status)
        }
        hx_record = hx_loanRecord?.filter { !$0.isEmpty } ?? []
    }
    
    init(){}
    
    static func hx_fakeData() -> HomeDataOutModel {
        let fakeData = HomeDataOutModel()
        fakeData.hx_userStatus = 10
        fakeData.hx_hasOrder = -999
        fakeData.hx_headerPrompt = "Please submit your personal information and get your loan amount"
        return fakeData
    }
    func hx_abTagutoPlaceOrderVaild(_ isCheck: Bool) -> Bool {
        if isCheck {
            let value = ViewSetting.shared.hx_kycComplete
            ViewSetting.shared.hx_kycComplete = false
            return value && hx_autoTakeOrder
        }
        return hx_autoTakeOrder
    }
}
