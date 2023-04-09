import UIKit

final class SearchNearLocationCell: UITableViewCell {

    struct Constants {
        static let horizontalPadding: CGFloat = 16
        static let spaceBetween2Items: CGFloat = 12
        static let designItemSize = CGSize(width: 120, height: 180)
        static let designScreenWidth: CGFloat = 375
        static var itemSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = screenWidth / designScreenWidth
            let itemWidth = designItemSize.width * ratio
            let itemHeight = designItemSize.height * ratio
            return CGSize(width: itemWidth, height: itemHeight)
        }()
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: BaseCollectionView!
    @IBOutlet private weak var heightCollectionView: NSLayoutConstraint!

    // MARK: - Public Variable

    var brands: [BrandModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
}

// MARK: - Private

private extension SearchNearLocationCell {
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SafeFoodBrandItem.self)

        heightCollectionView.constant = Constants.itemSize.height
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: 0, right: Constants.horizontalPadding)
    }

    func setupData(for cell: SafeFoodBrandItem, brand: BrandModel) {
        cell.title = brand.name
        cell.subtitle = brand.description
        cell.imageUrl = brand.logo
        cell.countStar = brand.ratingNumber
        cell.quantityOfVoted = brand.ratings
        cell.ratingStar = CGFloat(brand.ratings)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchNearLocationCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SafeFoodBrandItem.self, for: indexPath)
        setupData(for: cell, brand: brands[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchNearLocationCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController() {
            let vc = DetailBrandViewController.makeMe()
            vc.brandId = brands[indexPath.row].id
            topVC.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetween2Items
    }
}
