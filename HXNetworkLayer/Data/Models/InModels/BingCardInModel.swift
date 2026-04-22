//
//  BingCardInModel.swift
//  NIneUpdatea
//
//  Created by shuruiinfo on 2026/1/4.
//

import Foundation


public class BingCardInModel: NSObject {
    let hx_bankId: String?
    private var hx_callback: (([FormCellOutModel]?)->())?
    public init(_ hx_bankId: String? = nil) {
        self.hx_bankId = hx_bankId
    }
    public func hx_execute(closer: @escaping (([FormCellOutModel]?)->())) {
        hx_callback = { data in
            let hx_tmpData = data?.sorted { $0.hx_opionsSort < $1.hx_opionsSort }
            closer(hx_tmpData)
        }
                
        NetworkTool().url(hx_bingCard_url).params([:]).callback({[self] code, success , data in
            if success {
                let hx_data = JsonKit.hx_jsonToModel(data, modelType: CardViewOutModel.self)
                
                hx_data?.hx_payAccountInfoItemDtoList?.append(FormCellOutModel(hx_required: 0, hx_opionsCode: "hxrecordId", hx_visible: false))
                hx_data?.hx_payAccountInfoItemDtoList?.append(FormCellOutModel(hx_required: 0, hx_opionsCode: "hxdefaultFlag", hx_opionsSort: 1000))

                if let _ = hx_bankId {
                    handleCardInfo(hx_data)
                } else {
                    if let hx_model = hx_data?.hx_payAccountInfoItemDtoList?.filter({ $0.hx_opionsCode == "account_name"}).first {
                        if let hx_value = LocalizationData.shared.hx_userData?.hx_userName {
                            hx_model.hx_optValue = hx_value
                            hx_model.hx_optType = "1"
                        }
                    }
                    hx_callback?(hx_data?.hx_payAccountInfoItemDtoList)
                }
            }
        }).request()
    }
    
    private func handleCardInfo(_ data: CardViewOutModel?) {
        let hx_model = CardListInModel()
        hx_model.hx_bankCardBindId = hx_bankId
        hx_model.hx_execute { hx_data in
            if let hx_card = hx_data?.first {
                EwalletInModel().hx_execute(hx_backType: hx_card.hx_accountType ?? "") { datas in
                    if let hx_datas = datas, !hx_datas.isEmpty {
                        if let hx_model = data?.hx_payAccountInfoItemDtoList?.filter({ $0.hx_opionsCode == "hxrecordId" }).first {
                            hx_model.hx_optValue = hx_card.hx_recordId
                            hx_model.hx_optType = "1"
                        }
                        if let hx_model = data?.hx_payAccountInfoItemDtoList?.filter({ $0.hx_opionsCode == "bank_name" }).first {
                            hx_model.hx_opions?.removeAll()
                            hx_model.hx_opions?.append(contentsOf: hx_datas)
                        }
                        if let hx_model = data?.hx_payAccountInfoItemDtoList?.filter({ $0.hx_opionsCode == "account_name"}).first {
                            hx_model.hx_optValue = hx_card.hx_accountName
                            hx_model.hx_optType = "1"
                        }
                        
                        if let hx_value = hx_card.hx_accountType,
                           let hx_model = data?.hx_payAccountInfoItemDtoList?.first(where: { $0.hx_opionsCode == "account_type" }) {
                            hx_model.hx_optDisplay = hx_value
                            hx_model.hx_optValue = hx_value
                            hx_model.hx_optType = "1"
                        }
                        
                        if let hx_value = hx_card.hx_bankName, let hx_supValue = hx_datas.first(where: { $0.hx_opetionLabel == hx_value }),
                           let hx_model = data?.hx_payAccountInfoItemDtoList?.first(where: { $0.hx_opionsCode == "bank_name" }) {
                            hx_model.hx_optDisplay = hx_value
                            hx_model.hx_optValue = hx_supValue.hx_opetionKey
                            hx_model.hx_optType = "1"
                        }
                        
                        if let hx_value = hx_card.hx_accountNo {
                            if let hx_model = data?.hx_payAccountInfoItemDtoList?.first(where: { $0.hx_opionsCode == "account_no" }) {
                                hx_model.hx_optValue = hx_value
                                hx_model.hx_optType = "1"
                            }
                        }
                        if let hx_value = hx_card.hx_defaultFlag {
                            if let hx_model = data?.hx_payAccountInfoItemDtoList?.first(where: { $0.hx_opionsCode == "hxdefaultFlag" }) {
                                hx_model.hx_optValue = hx_value
                                hx_model.hx_optType = "1"
                            }
                        }
                    }
                    self.hx_callback?(data?.hx_payAccountInfoItemDtoList)
                }
            }
        }
    }
}
