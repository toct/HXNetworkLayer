//
//  CardListInModel.swift
//  NIneUpdatea
//
//  Created by shuruiinfo on 2026/1/4.
//

import Foundation

public class CardListInModel: NSObject, Codable {
    var hx_bankCardBindId: String?
    
    enum CodingKeys: String, CodingKey {
        case hx_bankCardBindId = "bankCardBindId"
    }
    
    func hx_execute(closer: @escaping (([CardInfoOutModel]?)->())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_cardList_url).params(hx_dict).callback({ code, success , data in
            if success {
                let hx_data = JsonKit.hx_jsonToModel(data, modelType: CardAssetOutModel.self)
                closer(hx_data?.hx_payAccountInfoList)
            }
        }).request()
    }
}

