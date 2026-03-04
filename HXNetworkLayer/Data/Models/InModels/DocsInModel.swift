import Foundation

class DocsInModel: Codable {

    static let shared = DocsInModel()
    var hx_doc: [String: Any] = [:]
    
    let hx_category = "a888"
    
    static var hx_url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(String(describing: self))
    }
    
    init() {
        // 尝试从本地文件加载 hx_doc
        if let hx_data = try? Data(contentsOf: DocsInModel.hx_url),
           let hx_dict = try? JSONSerialization.jsonObject(with: hx_data) as? [String: Any] {
            hx_doc = hx_dict
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case hx_category = "categoryStr"
    }
    
    func text(_ key: String) -> String {
        
        if let hx_text = SharedModel.shared.hx_constactValue?[key] as? String, !hx_text.isEmpty {
            return hx_text
        }
    
        if hx_doc.isEmpty {
            hx_execute { [self] hx_dict in
                if !hx_dict.isEmpty {
                    hx_doc = hx_dict
                    // 保存到本地
                    if let hx_data = try? JSONSerialization.data(withJSONObject: hx_dict) {
                        try? hx_data.write(to: DocsInModel.hx_url)
                    }
                }
            }
        }
                
        if let dict = hx_doc[key] as? [String: String] {
            return dict["en"] ?? key
        }
        return key
    }
    
    func hx_execute(closer: @escaping (([String: Any]) -> ())) {
        guard let hx_dict = JsonKit.hx_modelToJsonObject(obj: self) else { return }
        NetworkTool().url("/app/v3/category/gory").params(hx_dict).hub(false).callback { _, success, hx_data in
            if success {
                if let hx_dict = hx_data as? [String: Any],
                   let docs = hx_dict["categor" + "yInfos"] as? [String: Any] {
                    closer(docs)
                }
            }
        }.request()
    }
}

// 全局函数，用于获取文档内容
func hx_commonDoc(_ key: String, _ holder: String = "") -> String {
    var hx_text = DocsInModel.shared.text(key)
    
    hx_text = hx_text.replacingOccurrences(of: "KT_APPNAME", with: DeviceInfoInModel.hx_appName())
    hx_text = hx_text.replacingOccurrences(of: "KT_CONTACTNUMBER", with: LocalizationData.shared.hx_config?.hx_dynamicParame?.hx_contactCount ?? "")
    hx_text = hx_text.replacingOccurrences(of: "KT_WEBSITELINK", with: LocalizationData.shared.hx_config?.hx_officialLk ?? "")
    hx_text = hx_text.replacingOccurrences(of: "KT_XXX", with: holder)
    hx_text = hx_text.replacingOccurrences(of: "KT_CONTACTNO", with: holder)
    return hx_text
}
