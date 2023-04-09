import UIKit

final class HomeHotVoucherCell: UICollectionViewCell {
    
    // MARK: - IBOutlet

    @IBOutlet private weak var upcomingLabel: UILabel!
    @IBOutlet private weak var upComingView: UIView!
    @IBOutlet private weak var imageView: BaseImageView!
}

// MARK: - Public

extension HomeHotVoucherCell {
    func setupdata(hotVoucher: VoucherModel) {
        imageView.setImage(with: hotVoucher.image,
                           placeholderImage: R.image.icPlaceholderImg())
        upComingView.isHidden = hotVoucher.status != .inactive
        upcomingLabel.text = "Upcoming"
    }
}
