import Foundation

struct MagicCardAPIClient {
  private init() {}
  static let manager = MagicCardAPIClient()
  
  private let urlStr = "https://api.magicthegathering.io/v1/cards?name="
  
  func getCards(matching searchTerm: String = "bolt",
                completionHandler: @escaping (Result<[MagicCard], AppError>) -> Void) {
    guard let formattedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
      completionHandler(.failure(.badURL))
      return
    }
    
    let fullUrlStr = urlStr + formattedSearchTerm
    
    guard let url = URL(string: fullUrlStr) else {
      completionHandler(.failure(.badURL))
      return
    }
    
    NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
      switch result {
      case let .success(data):
        let cards = MagicCard.getCards(from: data)
        completionHandler(.success(cards))
      case let .failure(error):
        completionHandler(.failure(error))
      }
    }
  }
}
