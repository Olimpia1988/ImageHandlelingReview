import XCTest
@testable import CollectionViewReview

class CollectionViewIntroductionTests: XCTestCase {

    func testMagicCardGetCards() {

        // Arrange

        let jsonData = getTestMagicCardJSONData()

        // Act

        let cards = MagicCard.getCards(from: jsonData)

        // Assert

        XCTAssertEqual(cards.count, 79)
    }

    private func getTestMagicCardJSONData() -> Data {
        guard let pathToData = Bundle.main.path(forResource: "cards", ofType: "json") else {
            fatalError("cards.json file not found")
        }
        let internalUrl = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: internalUrl)
            return data
        }
        catch {
            fatalError("An error occurred: \(error)")
        }
    }
}
