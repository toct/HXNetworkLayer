//
//  MentationInModel.swift
//  NIneUpdatea
//
//  Created by shuruiinfo on 2026/1/4.
//

import Foundation

class MentationInModel: NSObject, Codable {
    func hx_execute(closer: @escaping ((MentionsOutModel?) -> ()) ) {
        NetworkTool().url(hx_mentation_url).params().callback {code, success, data in
            if success {
                if let hx_dict = data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: MentionsOutModel.self)
                    closer(hx_data)
                }
            }
        }.request()
    }
}
