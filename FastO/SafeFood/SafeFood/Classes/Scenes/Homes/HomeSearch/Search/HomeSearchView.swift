import UIKit

protocol KeywordSearchDelegate: AnyObject {
    func addKeyword(keyword: String)
}

final class HomeSearchView: NibView {

    // MARK: - IBOutlet

    @IBOutlet private weak var searchButton: BaseButton!
    @IBOutlet private weak var searchTextField: BaseTextField!

    // MARK: - Public

    weak var homeRecentKeywordDelegate: HomeRecentKeywordDelegate?

    // MARK: - Lifecycle

    override func configureView() {
        super.configureView()
    }
    
    // MARK: - IBAction

    @IBAction private func searchButtonTapped(_ sender: Any) {
        if let topVC = UIViewController.topViewController() {
            let vc = SearchViewController.makeMe()
            vc.keywordSearchDelegate = self
            topVC.pushViewController(vc, animated: true)
        }
    }
}

extension HomeSearchView: KeywordSearchDelegate {
    func addKeyword(keyword: String) {
        keyword.isEmpty ? nil : homeRecentKeywordDelegate?.addKeyword(keyword: keyword)
    }
}
