class CardsOutModel: Codable {
    var  hx_cards: [CardDetailOutModel]
    enum CodingKeys:String, CodingKey {
        case  hx_cards = "bankCardList"
    }
}
