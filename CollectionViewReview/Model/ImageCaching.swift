import UIKit

final class ImageGetterManager {
  
  private init() {}
  
  static let cache = NSCache<NSString, UIImage>()
  
  static func getImage(urlStr: String, completionHandler: @escaping (Result<UIImage, AppError>) -> Void) {
    
    guard let url = URL(string: urlStr) else {
      completionHandler(.failure(.badURL))
      return
    }
    
    NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
      switch result {
      case .failure(let error):
        completionHandler(.failure(error))
      case .success(let imageData):
        DispatchQueue.main.async {
          if let image = UIImage(data: imageData) {
            cache.setObject(image, forKey: url.absoluteString as NSString)
            completionHandler(.success(image))
          }
        }
      }
    }
  }
  
  
  static func getImageFromCache(with url: String) -> UIImage? {
    if let image = cache.object(forKey: url as NSString) {
      return image
    } else {
      return nil
    }
  }
}
