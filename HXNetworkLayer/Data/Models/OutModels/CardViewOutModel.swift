//
//  CardViewOutModel.swift
//  HXNetworkLayer
//
//  Created by mc on 3/3/26.
//

import Foundation

class CardViewOutModel: NSObject, Codable  {
    var hx_payAccountInfoItemDtoList: [FormCellOutModel]?
    enum CodingKeys:String, CodingKey {
        case  hx_payAccountInfoItemDtoList = "payAccountInfoItemDtoList"
    }
}
