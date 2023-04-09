import UIKit

final class DetailProductViewController: BaseViewController {

    struct Constants {
        static let minCountProduct = 0
        static let maxCountProduct = 99
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var productImageView: BaseImageView!
    @IBOutlet private weak var nameProductLabel: UILabel!
    @IBOutlet private weak var statusProductLabel: UILabel!
    @IBOutlet private weak var descriptionProductLabel: UILabel!
    @IBOutlet private weak var numberProductLabel: UILabel!
    @IBOutlet private weak var priceAfterDiscountLabel: UILabel!
    @IBOutlet private weak var totalProductLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var localizedTotalPaymentLabel: UILabel!
    @IBOutlet private weak var titleProductLabel: UILabel!
    @IBOutlet private weak var minusButton: BaseButton!
    @IBOutlet private weak var addButton: BaseButton!
    @IBOutlet private weak var sendButton: BaseButton!
    @IBOutlet private weak var backButton: BaseButton!
    
    // MARK: - Private Variable

    private var shopId: Int?
    private var type: ProductScreenType = .menu
    private lazy var presenter: DetailProductPresenter = {
        let presenter = DetailProductPresenter()
        presenter.view = self
        return presenter
    }()

    // MARK: - Public Variable

    var currentQuantity: Int = 0
    var countProduct: Int = 0
    weak var delegate: MenuBrandDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func applyLocalization() {
        localizedTotalPaymentLabel.text = R.string.localizable.detail_brand_total_payment.localized()
        sendButton.setTitle(R.string.localizable.detail_brand_add.localized(), for: .normal)
    }

    // MARK: - IBAction

    @IBAction private func backButtonTapped(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction private func sendButtonTapped(_ sender: Any) {
        guard let product = presenter.product else { return }
        switch type {
        case .menu:
            delegate?.totalDetailProduct(productId: product.id, changeQuantity: countProduct - currentQuantity, quantity: countProduct, price: product.price)
            popViewController(animated: true)
        case .recommend:
            if let topVC = UIViewController.topViewController(), let id = shopId {
                let vc = MenuBrandViewController.makeMe()
                vc.setupFromDetailProductToMenu(productId: product.id, quantity: countProduct, price: product.price)
                vc.setupData(shopId: id)
                topVC.pushViewController(vc, animated: true)
            }
        }
    }

    @IBAction private func minusButtonTapped(_ sender: Any) {
        countProduct -= 1
        setupUI()
    }

    @IBAction private func addButtonTapped(_ sender: Any) {
        countProduct += 1
        setupUI()
    }
}

// MARK: - Private

private extension DetailProductViewController {
    func setupUI() {
        guard let product = presenter.product else { return }
        let totalPayment = countProduct * product.price
        totalPriceLabel.text = "\(formatToString(number: totalPayment))VNĐ"

        numberProductLabel.text = "\(countProduct)"
        totalProductLabel.text = countProduct <= Constants.minCountProduct ? R.string.localizable.detail_brand_no_product.localized() : "\(countProduct) " + R.string.localizable.detail_brand_product.localized()
        enableMinusButton(countProduct > Constants.minCountProduct)
        enableAddButton(countProduct < Constants.maxCountProduct)
    }

    func enableMinusButton(_ enable: Bool) {
        minusButton.isEnabled = enable
        minusButton.tintColor = enable ? R.color.black100() : R.color.grayA2A2A3()
    }

    func enableAddButton(_ enable: Bool) {
        addButton.isEnabled = enable
        addButton.tintColor = enable ? R.color.black100() : R.color.grayA2A2A3()
    }
}

// MARK: - Public

extension DetailProductViewController {
    func setupData(quantity: Int, id: Int, type: ProductScreenType, shopId: Int?) {
        self.type = type
        self.shopId = shopId
        countProduct = quantity
        currentQuantity = quantity
        presenter.onViewDidLoad(with: id)
    }
}


// MARK: - DetailProductViewInput

extension DetailProductViewController: DetailProductViewInput {
    func reloadData() {
        guard let product = presenter.product else { return }
        titleProductLabel.text = product.name
        productImageView.setImage(with: product.image, placeholderImage: R.image.icPlaceholderImg())
        nameProductLabel.text = product.name
        priceAfterDiscountLabel.text = "\(product.price)VNĐ"
        statusProductLabel.isHidden = product.status != StatusProduct.recommend
        statusProductLabel.text = R.string.localizable.detail_brand_recommend.localized()
        numberProductLabel.text = "\(countProduct)"
        descriptionProductLabel.text = "Description short :" + "\(product.description)"
        enableMinusButton(countProduct > Constants.minCountProduct)
        enableAddButton(countProduct < Constants.maxCountProduct)
        if countProduct < 1 {
            totalProductLabel.text = "no product"
        } else if countProduct < 2 {
            totalProductLabel.text = "\(countProduct) product"
        } else {
            totalProductLabel.text = "\(countProduct) products"
        }
        totalPriceLabel.text = "\(countProduct * product.price)VNĐ"
    }
}
