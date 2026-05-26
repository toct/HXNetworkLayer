//
//  ABPageOutModel.swift
//  pertainTurn
//
//  Created by Zhuanz密码0000 on 2025/6/6.
//

import Foundation

// MARK: - DataClass
struct ABPageOutModel: Codable {
    /// AB面开关，0是A面、1是B面
    var hx_adContent: String?
    
    enum CodingKeys:String, CodingKey {
        case hx_adContent = "adContent"
    }
}
