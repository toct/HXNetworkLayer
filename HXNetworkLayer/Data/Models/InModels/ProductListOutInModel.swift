//
//  ProductListOutInModel.swift
//  tinyCircle
//
//  Created by shuruiinfo on 2025/9/22.
//

import Foundation

public class ProductListOutInModel: NSObject {
    
    public func hx_execute(closer: @escaping (([ProductOutModel]?) -> ()) ) {
        NetworkTool().url(hx_list_url).params().callback {_, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: ProductListOutModel.self)
                    closer(hx_data?.hx_productInfoList)
                }
            }
        }.request()
    }
}
