import UIKit
import HCSStarRatingView

final class BrandInformationView: NibView {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var brandImageView: BaseImageView!
    @IBOutlet private weak var brandName: UILabel!
    @IBOutlet private weak var brandDescription: UILabel!
    @IBOutlet private weak var totalReview: UILabel!
    @IBOutlet private weak var ratingView: HCSStarRatingView!
    
    // MARK: - Public Variable
    
    var brand: BrandModel? {
        didSet {
            updateUI(with: brand)
        }
    }
}

// MARK: - Private

private extension BrandInformationView {
    func updateUI(with brand: BrandModel?) {
        guard let brand = brand else { return }
        brandImageView.setImage(with: brand.logo, placeholderImage: R.image.icPlaceholderImg())
        brandName.text = brand.name
        brandDescription.text = brand.description
        totalReview.text = "\(brand.ratings)"
        ratingView.value = CGFloat(brand.ratingNumber)
        ratingView.isUserInteractionEnabled = false
    }
}
