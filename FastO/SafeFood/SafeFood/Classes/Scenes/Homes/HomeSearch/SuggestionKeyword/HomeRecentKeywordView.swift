import UIKit

protocol RecentKeywordDelegate: AnyObject {
    func removeKeyword(keyword: String)
}

final class HomeRecentKeywordView: NibView {

    struct Constants {
        static let horizontalPadding: CGFloat = 16
        static let spaceBetween2Items: CGFloat = 12
        static let minItemWidth: CGFloat = 31
        static let minStringSize: CGSize = CGSize(width: 0, height: 20)
        static let designItemSize = CGSize(width: 120, height: 24)
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

    // MARK: - Public Variable

    var listKeyword: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    weak var homeRecentKeywordDelegate: HomeRecentKeywordDelegate?

    // MARK: Lifecycle

    override func configureView() {
        super.configureView()
        setupCollectionView()
    }
}

// MARK: - Private

private extension HomeRecentKeywordView {
    func setupCollectionView() {
        collectionView.register(RecentKeywordCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: 0, right: Constants.horizontalPadding)
    }

}

// MARK: - UICollectionViewDataSource

extension HomeRecentKeywordView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listKeyword.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(RecentKeywordCell.self, for: indexPath)
        cell.recentKeywordDelegate = self
        cell.updateUI(keyword: listKeyword[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeRecentKeywordView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController() {
            let vc = SearchViewController.makeMe()
            vc.keyword = listKeyword[indexPath.item]
            vc.keywordSearchDelegate = self
            homeRecentKeywordDelegate?.addKeyword(keyword: listKeyword[indexPath.item])
            topVC.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = listKeyword[indexPath.item]
        let rect = text.boundingRect(with: Constants.minStringSize, options: NSStringDrawingOptions.usesFontLeading, attributes: [NSAttributedString.Key.font: R.font.lexendLight(size: 12)!], context: nil)

        return CGSize(width: rect.size.width + Constants.minItemWidth, height: Constants.itemSize.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetween2Items
    }
}

// MARK: - RecentKeywordDelegate

extension HomeRecentKeywordView: RecentKeywordDelegate {
    func removeKeyword(keyword: String) {
        homeRecentKeywordDelegate?.removeKeyword(keyword: keyword)
    }
}

// MARK: - KeywordSearchDelegate

extension HomeRecentKeywordView: KeywordSearchDelegate {
    func addKeyword(keyword: String) {
        keyword.isEmpty ? nil : homeRecentKeywordDelegate?.addKeyword(keyword: keyword)
    }
}
