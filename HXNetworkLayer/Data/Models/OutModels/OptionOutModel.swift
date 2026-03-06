public class OptionOutModel:NSObject, Codable {
    
    public var hx_opetionKey: String?
    public var hx_opetionLabel: String?
    public var hx_opetionSort: Int?
    private var hx_key: String?
    private var hx_label: String?
    private var hx_sort: Int?
    enum CodingKeys:String, CodingKey {
        case hx_opetionKey = "buttonKey"
        case hx_opetionLabel = "buttonLabel"
        case hx_opetionSort = "buttonSort"
        case hx_key = "key"
        case hx_label = "label"
        case hx_sort = "sort"
    }
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hx_opetionKey = try container.decodeIfPresent(String.self, forKey: .hx_opetionKey) ?? container.decodeIfPresent(String.self, forKey: .hx_key)
        self.hx_opetionLabel = try container.decodeIfPresent(String.self, forKey: .hx_opetionLabel) ?? container.decodeIfPresent(String.self, forKey: .hx_label)
        self.hx_opetionSort = try container.decodeIfPresent(Int.self, forKey: .hx_opetionSort) ?? container.decodeIfPresent(Int.self, forKey: .hx_sort)
    }
    
    public init(hx_opetionKey: String? = nil, hx_opetionLabel: String? = nil, hx_opetionSort: Int? = nil) {
        self.hx_opetionKey = hx_opetionKey
        self.hx_opetionLabel = hx_opetionLabel
        self.hx_opetionSort = hx_opetionSort
    }
}
