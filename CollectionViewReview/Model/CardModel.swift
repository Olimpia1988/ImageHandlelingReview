import Foundation

struct ResultsWrapper: Codable {
    let cards: [MagicCard]
}

struct MagicCard: Codable {
    let name: String
    let text: String?
    let imageUrl: String?
    static func getCards(from data: Data) -> [MagicCard] {
        do {
            let results = try JSONDecoder().decode(ResultsWrapper.self, from: data)
            return results.cards
        } catch {
            print("Decoding Error: ", error)
            fatalError()
        }
    }
}
