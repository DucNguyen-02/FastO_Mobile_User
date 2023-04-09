import UIKit
import HCSStarRatingView

final class SafeFoodVoucherRow: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var upComingView: UIView!
    @IBOutlet private weak var detailBrandImageView: BaseImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var soldCountLabel: UILabel!
    @IBOutlet private weak var timeApplyLabel: UILabel!
    @IBOutlet private weak var discountPercentLabel: UILabel!
    @IBOutlet private weak var currentPriceLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var discountTypeLabel: UILabel!
    @IBOutlet private weak var upcomingLabel: UILabel!
    @IBOutlet private weak var percentImageView: UIImageView!

    // MARK: - Private Variable

    private lazy var textAttributes: [NSAttributedString.Key: Any] = [
        .font: R.font.lexendRegular(size: 10)!,
        .foregroundColor: R.color.grayA2A2A3() ?? .gray,
        .strikethroughStyle: NSUnderlineStyle.single.rawValue
    ]
    
    // MARK: - Public
    
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
            descriptionLabel.isHidden = descriptionText == nil
        }
    }
    var soldCountText: String? {
        didSet {
            soldCountLabel.text = soldCountText
            soldCountLabel.isHidden = soldCountText == nil
        }
    }
    
    var isShowUpcomingView: Bool? {
        didSet {
            upComingView.isHidden = isShowUpcomingView ?? true
            upcomingLabel.text = "Up coming"
        }
    }
    
    var timeApplyText: String? {
        didSet {
            timeApplyLabel.text = "Áp dụng từ ngày: \(timeApplyText ?? "")"
            timeApplyLabel.isHidden = timeApplyText == nil
        }
    }

    var numberCount: String? {
        didSet {
            numberLabel.text = numberCount
            numberLabel.isHidden = numberCount == nil
        }
    }

    var name: String? {
        didSet {
            nameLabel.text = name.orEmpty
        }
    }
    var discount: Int? {
        didSet {
            discountPercentLabel.isHidden = discount == nil
            discountPercentLabel.text = "-\(formatToString(number: discount.orEmpty))"
        }
    }
    var discountType: String? {
        didSet {
            discountTypeLabel.text = discountType
            discountTypeLabel.isHidden = discountType == nil
        }
    }
    var isShowPercentImage: Bool? {
        didSet {
            percentImageView.isHidden = isShowPercentImage ?? true
        }
    }
    
    var currentPrice: Double? {
        didSet {
            currentPriceLabel.isHidden = currentPrice == nil
        }
    }
    var urlString: String? {
        didSet {
            detailBrandImageView.setImage(with: urlString.orEmpty,
                                          placeholderImage: R.image.icPlaceholderImg())
        }
    }
}

// MARK: - Private

extension SafeFoodVoucherRow {
    func setupData() {
        let mockUrl = "https://cdn.sforum.vn/sforum/wp-content/uploads/2022/04/15-7-scaled-e1650708800882.jpg"
        detailBrandImageView.setImage(with: mockUrl, placeholderImage: nil)
    }
}
