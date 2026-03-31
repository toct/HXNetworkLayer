//
//  ABPageInModel.swift
//  DarWinFiShu
//
//  Created by panda on 28/07/25.
//

import Foundation

class ABPageInModel: NSObject, Codable {
    var hx_simCardCount: String? = "1"

    enum CodingKeys: String, CodingKey {
        case hx_simCardCount = "simCardCount"
    }
    /// simCardCount 获取方式参考设备信息,设备信息中，该参数已删除，该处有异议
    override init() {
//        hx_simCardCount = SharedModel.hx_SIMInfo()["simCards"]
    }
    func hx_execute(closer: @escaping ((Bool)->())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url(hx_ab_page).params(hx_dict).callback({ _, success, hx_data in
            if success {
                if let hx_dict = hx_data as? Dictionary<String, Any> {
                    let hx_data = JsonKit.hx_jsonToModel(hx_dict, modelType: ABPageOutModel.self)
                    LocalizationData.shared.hx_abTag = hx_data?.hx_adContent
                }
            }
        }).request()
    }
}
