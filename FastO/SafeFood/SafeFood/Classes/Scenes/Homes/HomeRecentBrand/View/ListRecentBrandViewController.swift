import UIKit

final class ListRecentBrandViewController: BaseViewController {
    struct Constants {
        static let topPadding: CGFloat = 16
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
    
    @IBOutlet private weak var baseCollectionView: BaseCollectionView!

    // MARK: - Private Variable

    private lazy var presenter: HomeRecentBrandPresenter = {
        let presenter = HomeRecentBrandPresenter()
        presenter.view = self
        return presenter
    }()
    
    // MARK: - Public Variable
    
    var recentBrands: [BrandModel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func applyLocalization() {
        title = "Recent View"
    }
}

// MARK: - Private

private extension ListRecentBrandViewController {
    func setupUI() {
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = Constants.itemSize
        flowLayout.minimumLineSpacing = Constants.spaceBetween2Items
        flowLayout.minimumInteritemSpacing = Constants.spaceBetween2Items
        baseCollectionView.collectionViewLayout = flowLayout
        baseCollectionView.register(SafeFoodBrandItem.self)
        baseCollectionView.dataSource = self
        baseCollectionView.delegate = self
        baseCollectionView.contentInset = UIEdgeInsets(top: 12, left: Constants.horizontalPadding, bottom: 12, right: Constants.horizontalPadding)
    }
    
    func setupData(for cell: SafeFoodBrandItem, recentBrands: BrandModel) {
        cell.numberCount = nil
        cell.title = recentBrands.name
        cell.subtitle = recentBrands.description
        cell.imageUrl = recentBrands.banner
        cell.ratingStar = CGFloat(recentBrands.ratingNumber)
        cell.countStar = recentBrands.ratingNumber
        cell.quantityOfVoted = recentBrands.ratings
    }
}

// MARK: - UICollectionViewDataSource

extension ListRecentBrandViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentBrands.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SafeFoodBrandItem.self, for: indexPath)
        setupData(for: cell, recentBrands: recentBrands[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ListRecentBrandViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController {
            let id = recentBrands[indexPath.row].id
            presenter.onViewDidLoad(id: id)
            let vc = DetailBrandViewController.makeMe()
            vc.brandId = id
            topVC.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ListRecentBrandViewController: UICollectionViewDelegateFlowLayout {
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

extension ListRecentBrandViewController: HomeRecentBrandViewInput {}
