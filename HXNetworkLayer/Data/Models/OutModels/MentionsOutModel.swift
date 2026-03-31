class MentionsOutModel: Codable {
    var  hx_mentions: [MentionListOutModel]
    enum CodingKeys:String, CodingKey {
        case  hx_mentions = "mentationInfoList"
    }
}
