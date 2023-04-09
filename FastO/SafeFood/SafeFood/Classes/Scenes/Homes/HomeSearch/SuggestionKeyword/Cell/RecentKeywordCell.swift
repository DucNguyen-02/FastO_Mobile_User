import UIKit

final class RecentKeywordCell: UICollectionViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var keywordLabel: UILabel!
    @IBOutlet private weak var closeButton: BaseButton!

    // MARK: - Public Variable

    var recentKeywordDelegate: RecentKeywordDelegate?

    var keyword: String = ""

    // MARK: - IBAction

    @IBAction private func closeButtonTapped(_ sender: Any) {
        recentKeywordDelegate?.removeKeyword(keyword: keyword)
    }
}

// MARK: - Public

extension RecentKeywordCell {
    func updateUI(keyword: String) {
        self.keyword = keyword
        keywordLabel.text = keyword
    }
}
