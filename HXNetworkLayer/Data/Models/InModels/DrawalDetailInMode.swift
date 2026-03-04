//
//  DrawalDetailInMode.swift
//  autoPublisheder
//
//  Created by shuruiinfo on 2025/11/17.
//

import Foundation

class DrawalDetailInMode: NSObject, Codable {
    var hx_orderId: String?
    var hx_productId: String?
    enum CodingKeys: String, CodingKey {
        case hx_orderId = "orderId"
        case hx_productId = "productId"
    }
    func hx_execute(closer: @escaping ((OrderDetailOutModel) -> ())) {
        
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_withdrawaldetail_url).params(hx_dict, signedKeys:["orderId"]).callback({_, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    var hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: ProductDetailOutModel.self)
                    hx_data?.hx_isOrderData = true
                    hx_data?.hx_oStatus = 32
                    let hx_model = OrderDetailOutModel()
                    hx_model.hx_productModel = hx_data
                    closer(hx_model)
                }
            }
        }).request()
    }
}
