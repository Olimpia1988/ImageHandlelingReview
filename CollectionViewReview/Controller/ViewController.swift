import UIKit

class ViewController: UIViewController {
  
  var cards = [MagicCard]() {
    didSet {
      DispatchQueue.main.async {
        self.cardCollectionView.reloadData()
      }
    }
  }
  
  @IBOutlet weak var cardCollectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    loadCardData()
  }
  
  private func configureCollectionView() {
    cardCollectionView.dataSource = self
    cardCollectionView.delegate = self
  }
  
  private func loadCardData() {
    MagicCardAPIClient.manager.getCards { [weak self] (result) in
      DispatchQueue.main.async {
        switch result {
        case let .success(dataCards):
          self?.cards = dataCards
        case let .failure(error):
          print("An error occured: \(error)")
        }
      }
    }
  }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cards.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCell else { return UICollectionViewCell() }
    let singleCard = cards[indexPath.row]
    cell.configureCell(singleCard) { }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let orientation = UIApplication.shared.statusBarOrientation
    if (orientation == .landscapeLeft || orientation == .landscapeRight) {
      return CGSize(width: (collectionView.bounds.width - 10) / 2, height: collectionView.bounds.width / 2.2)
    } else {
      return CGSize(width: (collectionView.bounds.width - 5) / 2, height: (collectionView.bounds.width / 1.5))
    }
  }
}

