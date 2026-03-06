public class CardsOutModel: Codable {
    public var  hx_cards: [CardDetailOutModel]
    enum CodingKeys:String, CodingKey {
        case  hx_cards = "bankCardList"
    }
}
