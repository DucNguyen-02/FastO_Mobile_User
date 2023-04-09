import UIKit

final class SearchResultBrandCell: UITableViewCell {

    struct Constants {
        static let numberItems: Int = 4
        static let horizontalPadding: CGFloat = 16
        static let spaceBetween2Items: CGFloat = 16
        static var itemSize: CGSize = {
            let numberItemInRow: CGFloat = 2
            let screenWidth = UIScreen.main.bounds.width
            let totalOffset = horizontalPadding * 2 + spaceBetween2Items * (numberItemInRow - 1)
            var itemWidth = (screenWidth - totalOffset) / numberItemInRow
            itemWidth.round(.down)
            let itemHeight: CGFloat = 200
            return CGSize(width: itemWidth, height: itemHeight)
        }()
    }
    
    // MARK: - IBOutlet

    @IBOutlet private weak var collectionView: BaseCollectionView!
    @IBOutlet private weak var heightCollectionView: NSLayoutConstraint!

    // MARK: - Public Variable

    var brands: [BrandModel] = [] {
        didSet {
            heightCollectionView.constant = (brands.count / 2) > 1 ? Constants.itemSize.height * 2 + Constants.horizontalPadding : Constants.itemSize.height
            collectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}

// MARK: - Private

private extension SearchResultBrandCell {
    func setupUI() {
        collectionView.register(SafeFoodBrandItem.self)
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: 0, right: Constants.horizontalPadding)
    }

    func setupDataBrand(for cell: SafeFoodBrandItem, brand: BrandModel) {
        cell.title = brand.name
        cell.subtitle = brand.description
        cell.imageUrl = brand.logo
        cell.countStar = brand.ratingNumber
        cell.quantityOfVoted = brand.ratings
        cell.ratingStar = CGFloat(brand.ratingNumber)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchResultBrandCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands.count > Constants.numberItems ? Constants.numberItems : brands.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SafeFoodBrandItem.self, for: indexPath)
        setupDataBrand(for: cell, brand: brands[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchResultBrandCell: UICollectionViewDelegateFlowLayout {
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetween2Items
    }
}
