import UIKit

final class SearchHotVoucherItem: UICollectionViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var voucherImageView: BaseImageView!

    // MARK: - Public Variable

    var image: String? {
        didSet {
            voucherImageView.setImage(with: image.orEmpty, placeholderImage: R.image.icPlaceholderImg())
        }
    }
}
