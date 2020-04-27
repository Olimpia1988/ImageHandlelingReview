import UIKit


class CardCell: UICollectionViewCell {
  
  override func prepareForReuse() {
    super.prepareForReuse()
    print("prepareForReuse is getting called")
  }
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var cardImage: UIImageView!
  
  public func configureCell(_ magicCard: MagicCard, completionHandler: @escaping() -> Void) {
    imageSetup(magicCard) { }
  }
  
  public func imageSetup(_ magicCard: MagicCard, completionHandler: @escaping()-> Void) {
    if let safeImage = magicCard.imageUrl {
      if let imageFromCache = ImageGetterManager.getImageFromCache(with: safeImage) {
        self.cardImage.image = imageFromCache
      } else {
        ImageGetterManager.getImage(urlStr: safeImage) { (result) in
          switch result {
          case .failure(let error):
            print(error)
          case .success(let imageData):
            self.cardImage.image = imageData
            completionHandler()
          }
        }
      }
    }
  }
}
