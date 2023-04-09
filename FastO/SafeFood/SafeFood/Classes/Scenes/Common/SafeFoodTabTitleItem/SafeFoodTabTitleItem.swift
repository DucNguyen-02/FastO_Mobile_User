import UIKit

final class SafeFoodTabTitleItem: UICollectionViewCell {
    
    private struct Constants {
        struct Title {
            static let unselectFont: UIFont = R.font.lexendRegular(size: 12)!
            static let selectedFont: UIFont = R.font.lexendBold(size: 12)!
            static let unselectTextColor: UIColor = R.color.grayA2A2A3() ?? .gray
            static let selectedTextColor: UIColor = R.color.black100() ?? .black
        }
        struct Underline {
            static let unselectBgColor: UIColor = R.color.grayE8E8E8() ?? .gray
            static let selectedBgColor: UIColor = R.color.black100() ?? .black
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var seperatorView: UIView!
    
    // MARK: - Public Variable
    
    var unselectTitleFont: UIFont = Constants.Title.unselectFont
    var selectedTitleFont: UIFont = Constants.Title.selectedFont
    var unselectTextColor: UIColor = Constants.Title.unselectTextColor
    var selectedTextColor: UIColor = Constants.Title.selectedTextColor
    
    var unselectUnderlineColor: UIColor = Constants.Underline.unselectBgColor
    var selectedUnderlineColor: UIColor = Constants.Underline.selectedBgColor
    
    var title: String? {
        didSet {
            titleLabel.text = title
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

private extension SafeFoodTabTitleItem {
    func updateUI(isSelected: Bool) {
        seperatorView.backgroundColor = isSelected ? selectedUnderlineColor : unselectUnderlineColor
        titleLabel.textColor = isSelected ? selectedTextColor : unselectTextColor
        titleLabel.font = isSelected ? selectedTitleFont : unselectTitleFont
    }
}
