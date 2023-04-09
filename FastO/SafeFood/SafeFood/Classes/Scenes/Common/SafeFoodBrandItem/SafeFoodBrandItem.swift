//
//  DaPassLocationItem.swift
//  AppPass
//
//  Created by Bradley Hoang on 27/08/2022.
//

import UIKit
import HCSStarRatingView

final class SafeFoodBrandItem: UICollectionViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var detailBrandImageView: BaseImageView!
    @IBOutlet private weak var storeNameLabel: UILabel!
    @IBOutlet private weak var storeDescriptionLabel: UILabel!
    @IBOutlet private weak var ratingStarView: HCSStarRatingView!
    @IBOutlet private weak var countStarLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var quantityOfVotedLabel: UILabel!
    
    // MARK: - Public
    
    var title: String? {
        didSet {
            storeNameLabel.text = title
        }
    }
    var subtitle: String? {
        didSet {
            storeDescriptionLabel.text = subtitle
        }
    }
    var imageUrl: String? {
        didSet {
            detailBrandImageView.setImage(with: imageUrl.orEmpty, placeholderImage: R.image.icPlaceholderImg())
        }
    }
    var ratingStar: CGFloat? {
        didSet {
            ratingStarView.value = ratingStar ?? 1
            ratingStarView.isHidden = ratingStar == nil
            ratingStarView.isUserInteractionEnabled = false
        }
    }
    var countStar: Double? {
        didSet {
            countStarLabel.text = String(format: "%.1f", countStar ?? 0)
            countStarLabel.isHidden = countStarLabel == nil
        }
    }
    var numberCount: String? {
        didSet {
            numberLabel.text = numberCount
            numberLabel.isHidden = numberCount == nil
        }
    }
    
    var quantityOfVoted: Int? {
        didSet {
            guard let quantityOfVoted = quantityOfVoted else { return }
            quantityOfVotedLabel.text = "(\(quantityOfVoted))"
        }
    }
}

// MARK: - Public

extension SafeFoodBrandItem {
    func setupData() {
        let mockUrl = "https://cdn.sforum.vn/sforum/wp-content/uploads/2022/04/15-7-scaled-e1650708800882.jpg"
        detailBrandImageView.setImage(with: mockUrl, placeholderImage: nil)
    }
}
