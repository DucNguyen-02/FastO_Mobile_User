import UIKit

final class SearchResultProductCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var productImageView: BaseImageView!
    @IBOutlet private weak var nameProductLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var priceBeforeDiscountLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var priceAfterDiscountLabel: UILabel!
    
    // MARK: - Private Variable
    
    private lazy var textAttributes: [NSAttributedString.Key: Any] = [
        .font: R.font.lexendRegular(size: 10)!,
        .foregroundColor: R.color.grayA2A2A3() ?? .gray,
        .strikethroughStyle: NSUnderlineStyle.single.rawValue
    ]
}

// MARK: - Public

extension SearchResultProductCell {
    func setupData(with product: ProductModel) {
        productImageView.setImage(with: product.image, placeholderImage: R.image.icPlaceholderImg())
        nameProductLabel.text = product.name
        descriptionLabel.text = product.description
        statusLabel.isHidden = product.status != .recommend
        statusLabel.text = R.string.localizable.detail_brand_recommend.localized()
        
        priceBeforeDiscountLabel.isHidden = true
        discountLabel.isHidden = true
        priceAfterDiscountLabel.text = "\(formatToString(number: product.price))VNĐ"
    }
}
