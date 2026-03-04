//
//  BingCardInModel.swift
//  NIneUpdatea
//
//  Created by shuruiinfo on 2026/1/4.
//

import Foundation

class BingCardInModel: NSObject, Codable {
    func hx_execute(closer: @escaping (([FormCellOutModel]?)->())) {
        NetworkTool().url(hx_bingCard_url).params([:]).callback({ code, success , data in
            if success {
                let hx_data = JsonKit.hx_jsonToModel(data, modelType: CardViewOutModel.self)
                closer(hx_data?.hx_payAccountInfoItemDtoList)
            }
        }).request()
    }
}
