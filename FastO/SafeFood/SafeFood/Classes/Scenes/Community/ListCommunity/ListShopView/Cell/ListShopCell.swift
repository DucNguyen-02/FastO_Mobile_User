import UIKit

final class ListShopCell: UICollectionViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var categoryLabel: UILabel!

    // MARK: - Public Variable

    var category: String? {
        didSet {
            categoryLabel.text = category
        }
    }

    // MARK: - Lifecycle

    override var isSelected: Bool {
        didSet {
            updateUI(isSelected: isSelected)
        }
    }
}

// MARK: - Private

private extension ListShopCell {
    func updateUI(isSelected: Bool) {
        categoryLabel.textColor = isSelected ? R.color.blue4789FA() : R.color.gray737374()
        backgroundColor = isSelected ? R.color.blueCCE4FF() : R.color.whiteF5F5F5()
    }
}
