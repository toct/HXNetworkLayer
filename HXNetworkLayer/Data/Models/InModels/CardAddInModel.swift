//
//  CardAddInModel.swift
//  NIneUpdatea
//
//  Created by shuruiinfo on 2026/1/4.
//

import Foundation

public class CardAddInModel:NSObject, Codable {
    public var hx_defaultFlag: String
    public var hx_recordId: String?
    public var hx_kycCommitItemList: [CommitItemInModel]?
    enum CodingKeys: String, CodingKey {
        case hx_defaultFlag = "defaultFlag"
        case hx_kycCommitItemList = "kycCommitItemList"
        case hx_recordId = "recordId"
    }
    
    public init(data:[FormCellOutModel]? = nil, flag: String, recordId: String? = nil) {
        var hx_models: [CommitItemInModel] = []
        
        if let hx_datas = data {
            for model in hx_datas {
                let hx_model = CommitItemInModel()
                hx_model.hx_itemValueType = model.hx_optType
                hx_model.hx_itemValue = model.hx_optValue
                hx_model.hx_itemCode = model.hx_opionsCode
                
                if let value = model.hx_optType, let value1 = model.hx_optValue, !value.isEmpty && !value1.isEmpty && model.hx_opionsCode != "confirm_account_no" {
                    hx_models.append(hx_model)
                }
            }
        }
        hx_kycCommitItemList = hx_models
        hx_defaultFlag = flag
        hx_recordId = recordId
    }
    
    public func hx_execute(closer: @escaping (([FormCellOutModel]?)->())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_recordId == nil ? hx_addCard_url : hx_updateCard_url).params(hx_dict).callback({ code, success , data in
            if success {
                closer(nil)
            }
        }).request()
    }
}
