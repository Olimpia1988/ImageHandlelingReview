import UIKit


class CardCell: UICollectionViewCell {
  
  override func prepareForReuse() {
    super.prepareForReuse()
    print("prepareForReuse is getting called")
    self.cardImage.image = nil
    self.activityIndicator.startAnimating()
  }
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var cardImage: UIImageView!
  
  public func configureCell(_ magicCard: MagicCard, completionHandler: @escaping() -> Void) {
    imageSetup(magicCard) {print("Got image from online") }
  }
  
  public func imageSetup(_ magicCard: MagicCard, completionHandler: @escaping()-> Void) {
    if let safeImage = magicCard.imageUrl {
      if let imageFromCache = ImageGetterManager.getImageFromCache(with: safeImage) {
        self.cardImage.image = imageFromCache
        print("got image from cache")
        self.activityIndicator.stopAnimating()
      } else {
        ImageGetterManager.getImage(urlStr: safeImage) { (result) in
          switch result {
          case .failure(let error):
            print(error)
            self.activityIndicator.stopAnimating()
          case .success(let imageData):
            self.cardImage.image = imageData
            self.activityIndicator.stopAnimating()
            completionHandler()
          }
        }
      }
    } else {
        activityIndicator.stopAnimating()
        self.cardImage.image = nil
    }
  }
}
