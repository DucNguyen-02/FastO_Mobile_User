//
//  DetailBrandReviewCell.swift
//  SafeFood
//
//  Created by Zipris on 28/11/2022.
//

import UIKit
import HCSStarRatingView

final class DetailBrandReviewCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var starView: HCSStarRatingView!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: BaseImageView!
}

// MARK: - Public

extension DetailBrandReviewCell {
    func setupData(review: ReviewModel) {
        avatarImageView.setImage(with: review.userImage, placeholderImage: R.image.icPlaceholderImg())
        nameLabel.text = review.userFirstName + " " + review.userLastName
        contentLabel.isHidden = review.content.isEmpty
        contentLabel.text = review.content
        starView.value = CGFloat(review.ratings)
    }
}
