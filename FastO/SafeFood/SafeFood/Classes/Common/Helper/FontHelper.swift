import UIKit

class FontHelper {
    static func getAttributes(_ font: UIFont, _ foregroundColor: UIColor) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: foregroundColor,
                NSAttributedString.Key.font: font]
    }
}
