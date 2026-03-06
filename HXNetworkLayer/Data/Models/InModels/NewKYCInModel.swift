//
//  NewKYCInModel.swift
//  NIneUpdatea
//
//  Created by shuruiinfo on 2026/1/5.
//

import Foundation
public class NewKYCInModel: NSObject {
    public func hx_execute(closer: @escaping ((String?)->())) {
        NetworkTool().url(hx_kycStatus_url).params([:]).callback {code, success, data in
            if success {
                if let hx_dict = data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: KYCItemUploadOutModel.self)
                    closer(hx_data?.hx_echoMap?.hx_willExecuteStepNumber)
                }
            }
            closer(nil)
        }.request()
    }
}


