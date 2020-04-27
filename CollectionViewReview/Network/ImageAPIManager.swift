import Foundation
import UIKit

class ImageAPIClient {
    private init() {}
    static let manager = ImageAPIClient()
    func loadImage(from urlStr: String,
                   completionHandler: @escaping (Result<UIImage, AppError>) -> Void) {
        guard let url = URL(string: urlStr) else {
            completionHandler(.failure(.badURL))
            return
        }
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
            switch result {
            case let .success(data):
                guard let onlineImage = UIImage(data: data) else {
                    completionHandler(.failure(.notAnImage))
                    return
                }
                completionHandler(.success(onlineImage))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
