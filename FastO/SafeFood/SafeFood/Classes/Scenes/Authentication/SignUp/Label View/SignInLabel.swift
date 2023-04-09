import UIKit
import TTTAttributedLabel

struct SignInLabelURL {
    static let signInLinkAction = "action://Signin"
}

final class SignInLabel: TTTAttributedLabel {

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

        let signIn = R.string.localizable.sign_in_option.localized()
        let fullText = String(format: R.string.localizable.sign_up_already_a_member.localized(), signIn)

        let attributedString = NSAttributedString(string: fullText,
                                                  attributes: textAttributes)
        text = attributedString

        let signUpLink = URL(string: SignInLabelURL.signInLinkAction)
        addLink(to: signUpLink, with: NSRange(fullText.range(of: signIn)!, in: fullText))
    }
}
