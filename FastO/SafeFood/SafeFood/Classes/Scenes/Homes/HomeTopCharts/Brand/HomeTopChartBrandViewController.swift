import UIKit

final class HomeTopChartBrandViewController: BaseViewController {
    
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

    // MARK: - Private Variable

    private lazy var presenter: HomeRecentBrandPresenter = {
        let presenter = HomeRecentBrandPresenter()
        presenter.view = self
        return presenter
    }()
    
    // MARK: - Public Variable

    var topBrands: [TopBrandModel] = [] {
        didSet {
            if collectionView != nil {
                collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private

private extension HomeTopChartBrandViewController {
    func setupUI() {
        collectionView.register(SafeFoodBrandItem.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: 0, right: Constants.horizontalPadding)
    }

    func setupData(for cell: SafeFoodBrandItem, topBrand: TopBrandModel) {
        cell.title = topBrand.name
        cell.subtitle = topBrand.description
        cell.imageUrl = topBrand.logo
        cell.countStar = topBrand.ratingNumber
        cell.quantityOfVoted = topBrand.ratings
        cell.ratingStar = CGFloat(topBrand.ratingNumber)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeTopChartBrandViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topBrands.count > Constants.numberItems ? Constants.numberItems : topBrands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SafeFoodBrandItem.self, for: indexPath)
        cell.numberCount = "\(indexPath.item + 1)"
        setupData(for: cell, topBrand: topBrands[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeTopChartBrandViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController {
            let id = topBrands[indexPath.row].id
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetween2Items
    }
}

// MARK: - HomeRecentBrandViewInput

extension HomeTopChartBrandViewController: HomeRecentBrandViewInput {}
