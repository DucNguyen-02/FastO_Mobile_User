import UIKit
import HCSStarRatingView

final class RatingViewController: BaseViewController {
    
    struct Constants {
        static let maxCharacter: Int = 500
        static let designViewSize = CGSize(width: 375, height: 500)
        static let designScreenWidth: CGFloat = 375
        static var viewSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = screenWidth / designScreenWidth
            let viewWidth = designViewSize.width * ratio
            let viewHeight = designViewSize.height * ratio
            return CGSize(width: viewWidth, height: viewHeight)
        }()
    }
    // MARK: - IBOutlet
    
    @IBOutlet private weak var titlePopupLabel: UILabel!
    @IBOutlet private weak var closeButton: BaseButton!
    
    @IBOutlet private weak var nameStoreLabel: UILabel!
    @IBOutlet private weak var titleBrandLabel: UILabel!
    
    @IBOutlet private weak var sendView: UIView!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var starView: HCSStarRatingView!
    @IBOutlet private weak var detailView: UIStackView!
    @IBOutlet private weak var remindLabel: UILabel!
    
    @IBOutlet private weak var contentTextView: PlaceholderTextView!
    @IBOutlet private weak var quantityOfContent: UILabel!
    @IBOutlet private weak var sendButton: BaseButton!
    @IBOutlet private weak var heightPopupView: NSLayoutConstraint!
    
    // MARK: - Private Variable
    
    private var shopId: Int?
    private var billId: Int?
    private var shopName: String = ""
    private lazy var presenter: RatingPresenter = {
      let presenter = RatingPresenter()
      presenter.view = self
      return presenter
    }()
    
    weak var delegate: ListVoucherDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func applyLocalization() {
        
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        guard let billId = billId, let shopId = shopId else { return }
        let review = RatingModel(billId: billId, shopId: shopId, content: contentTextView.text, rating: Int(starView.value))
        delegate?.reloadData()
        presenter.onViewDidLoad(review: review.toDictionary())
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Private

private extension RatingViewController {
    func setupUI() {
        contentTextView.delegate = self
        starView.addTarget(self, action: #selector(chooseStar), for: .touchUpInside)
        contentTextView.placeholderText = "Chia sẻ cho mình biết trải nghiệm của bạn nhé"
        heightPopupView.constant = Constants.viewSize.height
        nameStoreLabel.text = shopName
    }
    
    @objc func chooseStar() {
        detailView.isHidden = starView.value < 1
        sendView.isHidden = starView.value < 1
        if starView.value < 3 {
            remindLabel.text = "Xin lỗi vì bạn đã có trải nghiệm không tốt.\nCần thay đổi điều gì để tiếp tục phục vụ bạn?"
        } else if starView.value >= 3 && starView.value < 5 {
            remindLabel.text = "Bạn có thể cho biết\nCần cải thiện điều gì thêm?"
        } else if starView.value == 5 {
            remindLabel.text = "Cảm ơn bạn đã dành lời khen.\nBạn thích điều gì nhất ở cửa hàng?"
        }
    }
}

// MARK: - Public

extension RatingViewController {
    func setupData(billId: Int, shopId: Int, shopName: String) {
        self.billId = billId
        self.shopId = shopId
        self.shopName = shopName
    }
}

// MARK: - TextView Delegate

extension RatingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            guard let string = textView.text else { return false }
        if string.count >= Constants.maxCharacter {
                ToastHelper.showToast("Vui lòng nhập tối đa 500 ký tự")
            }
        
        let count = string.count + text.count - range.length
        quantityOfContent.text = "\(count)/\(Constants.maxCharacter)"
        return count < Constants.maxCharacter
    }
}

// MARK: - RatingViewInput

extension RatingViewController: RatingViewInput {
    func dismissView() {
        dismiss(animated: true)
    }
}
