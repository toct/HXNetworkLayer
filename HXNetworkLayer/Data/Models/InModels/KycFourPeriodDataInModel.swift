import Foundation

public class KycFourPeriodDataInModel: NSObject, Codable {
    public var hx_kycId: String?
    public var hx_type: FormType = .kyc
    private var hx_callback: (([FormCellOutModel]?)->())?
    enum CodingKeys: String, CodingKey {
        case hx_kycId = "kycId"
    }
    
    public func hx_execute(closer: @escaping (([FormCellOutModel]?)->())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        hx_callback = { data in
            let hx_tmpData = data?.sorted { $0.hx_opionsSort < $1.hx_opionsSort }
            closer(hx_tmpData)
        }
        
        NetworkTool().url(hx_kycFourPeriodData_url).params(hx_dict).callback { _, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: ContactKYCOutModel.self)
                    guard let hx_value = self.hx_kycId, let hx_models = hx_data?.hx_kycItemList else { return }
                    
                    if hx_value == "pay_account" {
                        let hx_value = FormCellOutModel(hx_opionsCode: "confirm_account_no", hx_opionsName: hx_commonDoc("n51"), hx_opionsSort: 60)
                        hx_data?.hx_kycItemList.append(hx_value)
                        self.hx_handlePayAccountData(hx_models)
                    } else if hx_value == "identity_liveness" {
                        self.hx_identityLivenessData(hx_models)
                    } else if hx_value == "personal" {
                        self.hx_personalData(hx_models)
                    } else {
                        self.hx_callback?(hx_data?.hx_kycItemList)
                    }
                }
            }
        }.request()
    }
    
    private func hx_personalData(_ data: [FormCellOutModel]) {
        if let hx_model = data.filter({ $0.hx_opionsCode == "province"}).first {
            ProvinceInModel().hx_execute { datas in
                if let data = datas, !data.isEmpty {
                    hx_model.hx_opions?.append(contentsOf: data)
                }
            }
        }
        hx_callback?(data)
    }
    
    private func hx_identityLivenessData(_ data: [FormCellOutModel]) {
        data.filter({ $0.hx_opionsCode != "identity_front_img" && $0.hx_opionsCode != "liveness_img"}).forEach { $0.hx_required = 0 }
        hx_callback?(data)
    }
    
    private func hx_handlePayAccountData(_ data: [FormCellOutModel]) {
        let group = DispatchGroup()
        var hx_tmpData = data  // 创建局部可变副本
        
        group.enter()
        BanksInModel().hx_execute { [self] datas in
            if let data = datas, !data.isEmpty {
                let hx_model = hx_tmpData.filter({ $0.hx_opionsCode == "bank_code" }).first
                hx_model?.hx_opions?.append(contentsOf: data)
                
                if hx_type == .bankCardModify {
                    BankCardsInModel().hx_execute { [self] bankData in
                        if let cardDetail = bankData?.hx_cards.first {
                            updateBankData(&hx_tmpData, with: cardDetail)
                        }
                        group.leave()
                    }
                } else{
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [self] in
            self.hx_callback?(hx_tmpData)
        }
    }
    
    private func updateBankData(_ hx_models: inout [FormCellOutModel], with hx_model: CardDetailOutModel) {
        let hx_datas: [(hx_key: String, hx_value: () -> (display: String?, value: String?))] = [
                ("account_name", { (hx_model.hx_accountName, hx_model.hx_accountName) }),
                ("bank_code", { (hx_model.hx_bankName, hx_model.hx_bankCode) }),
                ("account_type", { (hx_model.hx_accountType, hx_model.hx_accountType) }),
                ("account_no", { (hx_model.hx_accountNo, hx_model.hx_accountNo) }),
                ("confirm_account_no", { (hx_model.hx_accountNo, hx_model.hx_accountNo) }),
                ("identity_no", { (nil, hx_model.hx_identityNo) }),
                ("account_phone", { (nil, hx_model.hx_accountPhone) })
            ]
            
            for hx_data in hx_datas {
                if let model = hx_models.first(where: { $0.hx_opionsCode == hx_data.hx_key }) {
                    let (display, value) = hx_data.hx_value()
                    
                    if let display = display {
                        model.hx_optDisplay = display
                    }
                    if let value = value {
                        model.hx_optValue = value
                    }
                    model.hx_optType = "1"
                }
            }
    }
}
