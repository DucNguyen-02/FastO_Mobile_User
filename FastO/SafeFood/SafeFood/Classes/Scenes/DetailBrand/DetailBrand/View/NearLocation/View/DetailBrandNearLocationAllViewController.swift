import UIKit

final class DetailBrandNearLocationAllViewController: BaseViewController {
    
    struct Constants {
        static let verticalPadding: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let spaceBetweenTwoItems: CGFloat = 12
        static let designScreenWidth: CGFloat = 375
        static var itemSize: CGSize = {
            let numberItemInRow: CGFloat = 2
            let screenWidth = UIScreen.main.bounds.width
            let totalOffset = horizontalPadding * 2 + spaceBetweenTwoItems * (numberItemInRow - 1)
            var itemWidth = (screenWidth - totalOffset) / numberItemInRow
            itemWidth.round(.down)
            let itemHeight: CGFloat = 200
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

    var brands: [NearBrandModel] = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)
        setupCollectionView()
    }

    override func applyLocalization() {
        title = "This location near this brand"
    }

}

// MARK: - Private

private extension DetailBrandNearLocationAllViewController {
    func setupCollectionView() {
        collectionView.register(SafeFoodBrandItem.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: Constants.verticalPadding, left: Constants.horizontalPadding, bottom: Constants.verticalPadding, right: Constants.horizontalPadding)
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

extension DetailBrandNearLocationAllViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SafeFoodBrandItem.self, for: indexPath)
        setupData(for: cell, nearLocationBrands: brands[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailBrandNearLocationAllViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController {
            let id = brands[indexPath.row].id
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

extension DetailBrandNearLocationAllViewController: HomeRecentBrandViewInput {}
