//
//  ProductListOutModel.swift
//  tinyCircle
//
//  Created by shuruiinfo on 2025/9/22.
//

import Foundation

class ProductListOutModel: Codable, Equatable, Identifiable {
    static func == (lhs: ProductListOutModel, rhs: ProductListOutModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    /// 产品列表
    var hx_productInfoList: [ProductOutModel] = []
    /// 标签列表
    var hx_productLabelList: [ProductLabelOutModel] = []
        
    enum CodingKeys:String, CodingKey {
        case hx_productInfoList = "productInfoList"
        case hx_productLabelList = "productLabelList"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let hx_products = try container.decodeIfPresent([ProductOutModel].self, forKey: .hx_productInfoList)
        self.hx_productLabelList = try container.decodeIfPresent( [ProductLabelOutModel].self, forKey: .hx_productLabelList) ?? []
        
        
        self.hx_productInfoList = hx_products?
            .compactMap { product -> (product: ProductOutModel, amount: Double)? in
                guard let amount = Double(product.hx_highAmount ?? "") else {
                    return nil
                }
                return (product, amount)
            }
            .sorted { $0.amount > $1.amount }  // 降序排序
            .map { $0.product } ?? []  // 只保留原始对象
    }
}

