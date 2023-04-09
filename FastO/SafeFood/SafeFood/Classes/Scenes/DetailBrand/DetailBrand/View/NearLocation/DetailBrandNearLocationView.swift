import UIKit

final class DetailBrandNearLocationView: NibView {

    struct Constants {
        static let verticalPadding: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let spaceBetweenTwoItems: CGFloat = 12
        static let designItemSize = CGSize(width: 120, height: 190)
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

    // MARK: - Private Variable

    private lazy var presenter: HomeRecentBrandPresenter = {
        let presenter = HomeRecentBrandPresenter()
        presenter.view = self
        return presenter
    }()

    // MARK: - Public Variable

    var nearLocationBrands: [NearBrandModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle

    override func configureView() {
        super.configureView()
        setupCollectionView()
    }
}

// MARK: - Private

private extension DetailBrandNearLocationView {
    func setupCollectionView() {
        collectionView.register(SafeFoodBrandItem.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: Constants.verticalPadding, right: Constants.horizontalPadding)
    }

    func setupData(for cell: SafeFoodBrandItem, nearLocationBrands: NearBrandModel) {
        cell.numberCount = nil
        cell.title = nearLocationBrands.name
        cell.subtitle = nearLocationBrands.description
        cell.imageUrl = nearLocationBrands.logo
        cell.ratingStar = CGFloat(nearLocationBrands.ratingNumber)
        cell.countStar = nearLocationBrands.ratingNumber
        cell.quantityOfVoted = nearLocationBrands.ratings
    }
}

// MARK: - UICollectionViewDataSource

extension DetailBrandNearLocationView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearLocationBrands.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SafeFoodBrandItem.self, for: indexPath)
        setupData(for: cell, nearLocationBrands: nearLocationBrands[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailBrandNearLocationView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController {
            let id = nearLocationBrands[indexPath.row].id
            presenter.onViewDidLoad(id: id)
            let vc = DetailBrandViewController.makeMe()
            vc.brandId = id
            topVC.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetweenTwoItems
    }
}

// MARK: - HomeRecentBrandViewInput

extension DetailBrandNearLocationView: HomeRecentBrandViewInput {}
