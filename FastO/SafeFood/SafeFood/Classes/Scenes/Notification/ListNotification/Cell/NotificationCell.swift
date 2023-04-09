import UIKit

final class NotificationCell: UITableViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
}

// MARK: - Public

extension NotificationCell {
    func setupData(notification: NotificationModel) {
        titleLabel.text = notification.title
        timeLabel.text = notification.createdAt
        backgroundColor = notification.seenFlag ? R.color.white100() : R.color.whiteF5F5F5()

        let attrs1: [NSAttributedString.Key: Any] =
            [.font: R.font.lexendRegular(size: 12)!,
             .foregroundColor: R.color.gray737374()!]
        let attrs2: [NSAttributedString.Key: Any] =
            [.font: R.font.lexendRegular(size: 12)!,
            .foregroundColor: R.color.blue4789FA()!]
        let attributedString1 = NSMutableAttributedString(string: notification.content, attributes: attrs1)
        let attributedString2 = NSMutableAttributedString(string: " " + notification.typeName, attributes: attrs2)

        attributedString1.append(attributedString2)
        contentLabel.attributedText = attributedString1
    }
}
