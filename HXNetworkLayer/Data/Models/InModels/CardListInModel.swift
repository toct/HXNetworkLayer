//
//  CardListInModel.swift
//  NIneUpdatea
//
//  Created by shuruiinfo on 2026/1/4.
//

import Foundation

public class CardListInModel: NSObject, Codable {
    public func hx_execute(closer: @escaping (([CardInfoOutModel]?)->())) {
        NetworkTool().url(hx_cardList_url).params([:]).callback({ code, success , data in
            if success {
                let hx_data = JsonKit.hx_jsonToModel(data, modelType: CardAssetOutModel.self)
                closer(hx_data?.hx_payAccountInfoList)
            }
        }).request()
    }
}
