//
//  CommitItemInModel.swift
//  NIneUpdatea
//
//  Created by shuruiinfo on 2026/1/4.
//

import Foundation

public class CommitItemInModel: NSObject, Codable {
    public var hx_itemValueType: String?
    public var hx_itemValue: String?
    public var hx_itemCode: String?
    enum CodingKeys: String, CodingKey {
        case hx_itemValueType = "itemValueType"
        case hx_itemValue = "itemValue"
        case hx_itemCode = "itemCode"
    }
}
