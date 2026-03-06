//
//  WithDrawInModel.swift
//  autoPublisheder
//
//  Created by shuruiinfo on 2025/10/26.
//

import Foundation

public class WithDrawInModel: NSObject, Codable {
    public var hx_orderId: String?
    public var hx_loanAmount: String?
    public var hx_loanTerm: String?

    enum CodingKeys: String, CodingKey {
        case hx_orderId = "orderId"
        case hx_loanAmount = "loanAmount"
        case hx_loanTerm = "loanTerm"
    }
    
    public func hx_execute( closer: @escaping ((Bool)->Void)) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_withdrawal_url).params(hx_dict, signedKeys: ["orderId"]).callback({ _, success, _ in
            closer(success)
        }).request()
    }
}
