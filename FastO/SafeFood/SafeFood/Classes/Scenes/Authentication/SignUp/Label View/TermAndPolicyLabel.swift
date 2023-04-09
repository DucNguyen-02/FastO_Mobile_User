import UIKit
import TTTAttributedLabel

final class TermsAndPolicyLabel: TTTAttributedLabel {

    // MARK: - Private Variable

    private lazy var textAttributes: [NSAttributedString.Key: Any] = [
        .font: R.font.lexendRegular(size: 12)!,
        .foregroundColor: R.color.grayA2A2A3() ?? .gray,
        .underlineStyle: NSUnderlineStyle.single.rawValue
    ]

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        numberOfLines = 0
        let contentLabel = R.string.localizable.sign_up_need_accept_term_and_policy.localized()
        text = NSAttributedString(string: contentLabel, attributes: textAttributes)
    }
}
