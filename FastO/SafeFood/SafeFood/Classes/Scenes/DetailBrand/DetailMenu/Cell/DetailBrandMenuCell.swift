import UIKit

final class DetailBrandMenuCell: UITableViewCell {

    struct Constants {
        static let minCountProduct = 0
        static let maxCountProduct = 99
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var productImageView: BaseImageView!
    @IBOutlet private weak var nameProductLabel: UILabel!
    @IBOutlet private weak var totalUsedLabel: UILabel!
    @IBOutlet private weak var statusProductLabel: UILabel!
    @IBOutlet private weak var numberProductLabel: UILabel!
    @IBOutlet private weak var priceAfterDiscountLabel: UILabel!
    @IBOutlet private weak var minusButton: BaseButton!
    @IBOutlet private weak var addButton: BaseButton!

    // MARK: - Private Variable
    
    private var countProduct: Int = 0
    private var product: ProductModel?
    private lazy var textAttributes: [NSAttributedString.Key: Any] = [
        .font: R.font.lexendRegular(size: 10)!,
        .foregroundColor: R.color.grayA2A2A3() ?? .gray,
        .strikethroughStyle: NSUnderlineStyle.single.rawValue
    ]
    
    // MARK: - Public Variable

    weak var delegate: MenuBrandDelegate?

    // MARK: - IBAction

    @IBAction private func minusTapped(_ sender: Any) {
        guard let product = product else { return }
        countProduct -= 1
        updateUI()
        delegate?.totalProduct(number: -1, productId: product.id, quantity: countProduct, price: product.price)
    }

    @IBAction private func addTapped(_ sender: Any) {
        guard let product = product else { return }
        countProduct += 1
        updateUI()
        delegate?.totalProduct(number: 1, productId: product.id, quantity: countProduct, price: product.price)

    }
}

// MARK: - Private

private extension DetailBrandMenuCell {
    func updateUI() {
        numberProductLabel.text = "\(countProduct)"
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

    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true

        let number = NSNumber(value: number)
        let numberString = numberFormatter.string(from: number).orEmpty
        return numberString
    }
}

// MARK: - Public

extension DetailBrandMenuCell {
    func setupData(with product: ProductModel, quantity: Int) {
        self.product = product
        self.countProduct = quantity
        productImageView.setImage(with: product.image, placeholderImage: R.image.icPlaceholderImg())
        nameProductLabel.text = product.name
        statusProductLabel.isHidden = product.status != StatusProduct.recommend
        statusProductLabel.text = "Recommend"
        numberProductLabel.text = "\(countProduct)"
        totalUsedLabel.text = "Used to \(product.countPay) people"
        priceAfterDiscountLabel.text = "\(numberFormatter(number: product.price))VNĐ"
        updateUI()
    }
}
