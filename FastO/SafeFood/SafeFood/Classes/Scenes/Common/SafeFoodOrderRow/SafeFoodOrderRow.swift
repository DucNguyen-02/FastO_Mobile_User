import UIKit
import HCSStarRatingView

final class SafeFoodOrderRow: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var baseImageView: BaseImageView!
    @IBOutlet private weak var blurView: UIView!
    @IBOutlet private weak var repurchaseView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var rateView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var starView: HCSStarRatingView!
    @IBOutlet private weak var currentPriceLabel: UILabel!
    
    // MARK: - Private Variable
    
    private var index: Int?
    
    // MARK: - Public
    
    weak var delegate: ListVoucherDelegate?
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(showRating))
        rateView.addGestureRecognizer(tap)
    }
    
    // MARK: - Public
    
    var isRepurchase: Bool? {
        didSet {
            repurchaseView.isHidden = isRepurchase ?? true
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name.orEmpty
            nameLabel.isHidden = name == nil
        }
    }
    
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText.orEmpty
            descriptionLabel.isHidden = descriptionText == nil
        }
    }
    
    var timeText: String? {
        didSet {
            timeLabel.text = timeText.orEmpty
            timeLabel.isHidden = timeText == nil
        }
    }
    
    var priceText: String? {
        didSet {
            currentPriceLabel.text = priceText.orEmpty
            currentPriceLabel.isHidden = priceText == nil
        }
    }
    
    var imageUrl: String? {
        didSet {
            baseImageView.setImage(with: imageUrl.orEmpty,
                                   placeholderImage: R.image.icPlaceholderImg())
        }
    }
    
    var isShowBlurView: Bool? {
        didSet {
            blurView.isHidden = isShowBlurView ?? true
            let color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5980295345)
            blurView.backgroundColor = color
        }
    }
    
    func colorText(colorNametext: UIColor?, colorPriceText: UIColor? ) {
        nameLabel.textColor = colorNametext
        currentPriceLabel.textColor = colorPriceText
    }
    
    func rateView(rating: Int, isRating: Bool, index: Int) {
        rateView.isHidden = false
        ratingLabel.isHidden = isRating
        starView.value = CGFloat(rating)
        rateView.isUserInteractionEnabled = !isRating
        self.index = index
    }
    
    func setupData() {
        let mockUrl = "https://media.bongda.com.vn/files/anh.vu/2016/09/08/watermarked-3a2-1451.jpg"
        baseImageView.setImage(with: mockUrl, placeholderImage: nil)
    }
}

// MARK: - Private

private extension SafeFoodOrderRow {
    @objc func showRating() {
        guard let index = index else { return }
        delegate?.showRating(index)
    }
}

