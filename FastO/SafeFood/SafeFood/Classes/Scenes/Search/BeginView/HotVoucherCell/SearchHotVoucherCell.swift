import UIKit

final class SearchHotVoucherCell: UITableViewCell {

    struct Constants {
        static let horizontalPadding: CGFloat = 16
        static let spaceBetween2Line: CGFloat = 24
        static let spaceBetween2Items: CGFloat = 12
        static let designItemSize = CGSize(width: 320, height: 196)
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

    var hotVouchers: [VoucherModel] = [] {
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

private extension SearchHotVoucherCell {
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchHotVoucherItem.self)

        heightCollectionView.constant = Constants.itemSize.height
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: Constants.spaceBetween2Line, right: Constants.horizontalPadding)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchHotVoucherCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotVouchers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SearchHotVoucherItem.self, for: indexPath)
        cell.image = hotVouchers[indexPath.item].image
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchHotVoucherCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController {
            let vc = DetailVoucherViewController.makeMe()
            vc.voucherId = hotVouchers[indexPath.item].id
//            vc.statusType = hotVouchers[indexPath.item].status
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
