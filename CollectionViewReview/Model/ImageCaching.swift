import UIKit

final class ImageGetterManager {
  
  
     static let shared = ImageGetterManager()
    
    
  
    private var cache: NSCache<NSString, UIImage>
    
    
    private init() {
        cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100 // number of objects
        cache.totalCostLimit = 10 * 1024 * 1024 // max
    }
    
  
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
            ImageGetterManager.shared.cache.setObject(image, forKey: url.absoluteString as NSString)
            completionHandler(.success(image))
          }
        }
      }
    }
  }
  
  
  static func getImageFromCache(with url: String) -> UIImage? {
    if let image = ImageGetterManager.shared.cache.object(forKey: url as NSString) {
      return image
    } else {
      return nil
    }
  }
}
