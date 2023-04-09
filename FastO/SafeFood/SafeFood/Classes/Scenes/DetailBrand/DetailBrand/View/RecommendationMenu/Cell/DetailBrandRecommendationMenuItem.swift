import UIKit

final class DetailBrandRecommendationMenuItem: UICollectionViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var voucherImageView: BaseImageView!
    @IBOutlet private weak var nameVoucherLabel: UILabel!
    @IBOutlet private weak var totalUsedLabel: UILabel!
    @IBOutlet private weak var recommendLabel: UILabel!
    @IBOutlet private weak var priceAfterDiscountLabel: UILabel!

    // MARK: - Private Variable

    private lazy var textAttributes: [NSAttributedString.Key: Any] = [
        .font: R.font.lexendRegular(size: 10)!,
        .foregroundColor: R.color.grayA2A2A3() ?? .gray,
        .strikethroughStyle: NSUnderlineStyle.single.rawValue
    ]
}

// MARK: - Private

extension DetailBrandRecommendationMenuItem {
    func formatToString(number: Int) -> String {
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

extension DetailBrandRecommendationMenuItem {
    func setupData(menu: ProductModel) {
        voucherImageView.setImage(with: menu.image, placeholderImage: R.image.icPlaceholderImg())
        nameVoucherLabel.text = menu.name
        totalUsedLabel.text = "Used to \(menu.countPay) people"
        recommendLabel.text = R.string.localizable.detail_brand_recommend.localized()
        priceAfterDiscountLabel.text = "\(formatToString(number: menu.price))VNĐ"
    }
}
