import UIKit

final class SafeFoodVoucherItem: UICollectionViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var upcomingLabel: UILabel!
    @IBOutlet private weak var detailBrandImageView: BaseImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var discountTypeLabel: UILabel!
    @IBOutlet private weak var discountPercentLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var lightningImageView: UIImageView!
    @IBOutlet private weak var upComingView: UIView!
    
    // MARK: - Public
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var subtitle: String? {
        didSet {
            descriptionLabel.text = subtitle
        }
    }
    var imageUrl: String? {
        didSet {
            detailBrandImageView.setImage(with: imageUrl.orEmpty,
                                          placeholderImage: R.image.icPlaceholderImg())
        }
    }
    var isShowLightning: Bool = false {
        didSet {
            lightningImageView.isHidden = !isShowLightning
        }
    }
    var discountPercent: Int? {
        didSet {
            discountPercentLabel.text = "-\(numberFormatToString(number: discountPercent.orEmpty))"
            discountPercentLabel.isHidden = discountPercent == nil
        }
    }
    var price: String? {
        didSet {
            priceLabel.text = price
            priceLabel.isHidden = price == nil
        }
    }
    var discountType: String? {
        didSet {
            discountTypeLabel.text = discountType
            discountTypeLabel.isHidden = discountType == nil
        }
    }

    var isShowUpcomingView: Bool? {
        didSet {
            upComingView.isHidden = isShowUpcomingView ?? true
            upcomingLabel.text = "Upcoming"
        }
    }
}

// MARK: - Public

extension SafeFoodVoucherItem {
    func setupData() {
        let mockUrl = "https://cdn.sforum.vn/sforum/wp-content/uploads/2022/04/15-7-scaled-e1650708800882.jpg"
        detailBrandImageView.setImage(with: mockUrl, placeholderImage: nil)
    }
    
    func numberFormatToString(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true

        let number = NSNumber(value: number)
        let numberString = numberFormatter.string(from: number).orEmpty
        return numberString
    }
}
