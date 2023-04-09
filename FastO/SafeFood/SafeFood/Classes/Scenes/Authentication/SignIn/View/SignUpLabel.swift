import UIKit
import TTTAttributedLabel

struct SignUpLabelURL {
    static let signUpLinkAction = "action://Signup"
}

final class SignUpLabel: TTTAttributedLabel {

    // MARK: - Private Variable

    private lazy var  textAttributes: [NSAttributedString.Key: Any] = [
        .font: R.font.lexendRegular(size: 12)!,
        .foregroundColor: R.color.grayA2A2A3() ?? .gray
    ]

    // MARK: - Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        numberOfLines = 0

        let linkAttributes: [NSAttributedString.Key: Any] = [
            .font: R.font.lexendRegular(size: 12)!,
            .foregroundColor: R.color.grayA2A2A3() ?? .gray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        self.linkAttributes = linkAttributes
        self.activeLinkAttributes = linkAttributes

        let signUp = R.string.localizable.sign_up.localized()
        let fullText = String(format: R.string.localizable.sign_in_need_a_count.localized(), signUp)

        let attributedString = NSAttributedString(string: fullText,
                                                  attributes: textAttributes)
        text = attributedString

        let signUpLink = URL(string: SignInLabelURL.signInLinkAction)
        addLink(to: signUpLink, with: NSRange(fullText.range(of: signUp)!, in: fullText))
    }
}
