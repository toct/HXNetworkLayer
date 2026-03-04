
class KYCSOutModel: Codable
{
    private var hx_remoteKYCFlow: [String]?
    
    var hx_currentKYCId: String?
    
    private var hx_kycProcedure: [KycPeriodOutModel]?
    
    func hx_kycNextStep() -> String?{
        
        guard let periodId = hx_currentKYCId, let flow = hx_remoteKYCFlow else { return nil }
        
        if var index = flow.firstIndex(of: periodId)  {
            index += 1
            if index < flow.count {
                hx_currentKYCId = flow[index]
                return hx_currentKYCId
            }
        }
        return nil
    }
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_kycProcedure = try container.decodeIfPresent([KycPeriodOutModel].self, forKey: .hx_kycProcedure)
        hx_setupProperties()
    }
    
    private func hx_setupProperties() {
        guard let dataArr = hx_kycProcedure else {
            return
        }
        let sortedArr = dataArr.sorted(by: { $0.hx_periodSort < $1.hx_periodSort })
        
        hx_remoteKYCFlow = sortedArr.map { $0.hx_periodId ?? "" }
        
        let uncompletedKYCPeriods = sortedArr.filter { $0.hx_periodStatus ?? "" == "0"}
        
        hx_currentKYCId = uncompletedKYCPeriods.first?.hx_periodId
    }
    enum CodingKeys:String, CodingKey {
        case  hx_kycProcedure = "kycList"
    }
}
