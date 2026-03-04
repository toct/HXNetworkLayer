//
//  CommitItemInModel.swift
//  NIneUpdatea
//
//  Created by shuruiinfo on 2026/1/4.
//

import Foundation

class CommitItemInModel: NSObject, Codable {
    var hx_itemValueType: String?
    var hx_itemValue: String?
    var hx_itemCode: String?
    enum CodingKeys: String, CodingKey {
        case hx_itemValueType = "itemValueType"
        case hx_itemValue = "itemValue"
        case hx_itemCode = "itemCode"
    }
}
