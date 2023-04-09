import UIKit
import HCSStarRatingView

final class DetailBrandSummaryInformationView: NibView {

    struct Constants {
        static let designItemSize = CGSize(width: 375, height: 105)
        static let designScreenWidth: CGFloat = 375
        static var itemSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = screenWidth / designScreenWidth
            let itemWidth = designItemSize.width * ratio
            let itemHeight = designItemSize.height * ratio
            return CGSize(width: itemWidth, height: itemHeight)
        }()
    }
    
    // MARK: - IBOutlet

    @IBOutlet private weak var quantityOfVoted: UILabel!
    @IBOutlet private weak var likeButton: BaseButton!
    @IBOutlet private weak var nameBrandLabel: UILabel!
    @IBOutlet private weak var addressBrandLabel: UILabel!
    @IBOutlet private weak var timeBrandLabel: UILabel!
    @IBOutlet private weak var timeEventLabel: UILabel!
    @IBOutlet private weak var numberStarLabel: UILabel!
    @IBOutlet private weak var averageVotedStar: HCSStarRatingView!
    
    // MARK: - Private Variable
    
    private var isLike: Bool = false
    
    // MARK: - Public Variable
    
    weak var delegate: DetailBrandDelegate?
    
    // MARK: - IBAction
    
    @IBAction private func likeButtonTapped(_ sender: Any) {
        isLike.toggle()
        delegate?.likeBrand(isLike: isLike)
        let image = isLike ? R.image.heart_red() : R.image.ic_heart()
        likeButton.setImage(image, for: .normal)
    }
}

// MARK: - Private

private extension DetailBrandSummaryInformationView {
    func convertTime(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let convert = dateFormatter.date(from: time)!
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: convert)
    }
}

// MARK: - Public

extension DetailBrandSummaryInformationView {
    func setupData(_ detailBrand: ProfileBrandModel) {
        nameBrandLabel.text = detailBrand.name
        addressBrandLabel.text = detailBrand.town + " " + detailBrand.street + " " + detailBrand.city + " " + detailBrand.disctrict

        self.isLike = detailBrand.isFavourite
        let image = isLike ? R.image.heart_red() : R.image.ic_heart()
        likeButton.setImage(image, for: .normal)
        let open = "7:00"//convertTime(detailBrand.openTime)
        let close = "22:00"//convertTime(detailBrand.closeTime)
        timeBrandLabel.text = "\(open) - \(close) every day"
        numberStarLabel.text = String(format: "%.1f", detailBrand.ratingNumber)
        averageVotedStar.value = CGFloat(detailBrand.ratingNumber)
        quantityOfVoted.text = "(\(detailBrand.ratings))"
        averageVotedStar.isUserInteractionEnabled = false
    }
}
