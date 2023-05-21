import UIKit

final class HomeRecentBrandView: NibView {
    
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

    // MARK: - Private Variable

    private lazy var presenter: HomeRecentBrandPresenter = {
        let presenter = HomeRecentBrandPresenter()
        presenter.view = self
        return presenter
    }()

    // MARK: - Public Variable
    
    var recentBrands: [BrandModel] = [] {
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

private extension HomeRecentBrandView {
    func setupCollectionView() {
        collectionView.register(SafeFoodBrandItem.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: 0, right: Constants.horizontalPadding)
    }
    
    func setupData(for cell: SafeFoodBrandItem, recentBrand: BrandModel) {
        cell.title = recentBrand.name
        cell.subtitle = recentBrand.description
        cell.imageUrl = recentBrand.banner
        cell.ratingStar = CGFloat(recentBrand.ratingNumber)
        cell.countStar = recentBrand.ratingNumber
        cell.quantityOfVoted = recentBrand.ratings
    }
}

// MARK: - UICollectionViewDataSource

extension HomeRecentBrandView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentBrands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SafeFoodBrandItem.self, for: indexPath)
        setupData(for: cell, recentBrand: recentBrands[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeRecentBrandView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController {
            let id = recentBrands[indexPath.row].id
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
        return Constants.spaceBetween2Items
    }
}

// MARK: - HomeRecentBrandViewInput

extension HomeRecentBrandView: HomeRecentBrandViewInput {}
