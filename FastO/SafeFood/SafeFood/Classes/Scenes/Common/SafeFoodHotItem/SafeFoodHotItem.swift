//
//  SafeFoodHotItem.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 8/29/22.
//

import UIKit

final class SafeFoodHotItem: UICollectionViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var hotImageView: BaseImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var seeDetailButton: BaseButton!
    @IBOutlet private weak var soldCountLabel: UILabel!
    @IBOutlet private weak var averageVotedStarContainerView: UIStackView!
    @IBOutlet private weak var votedStarLabel: UILabel!
    @IBOutlet private weak var votedCountLabel: UILabel!
    
    // MARK: - Public

    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }

    var isShowSeeDetail: Bool = false {
        didSet {
            seeDetailButton.isHidden = !isShowSeeDetail
        }
    }

    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
            descriptionLabel.isHidden = descriptionText == nil
        }
    }

    var soldCountText: String? {
        didSet {
            soldCountLabel.text = soldCountText
            soldCountLabel.isHidden = soldCountText == nil
        }
    }

    var averageVotedStar: Int? {
        didSet {
            averageVotedStarContainerView.isHidden = averageVotedStar == nil
        }
    }

    var votedStar: String? {
        didSet {
            votedStarLabel.text = votedStar
            votedStarLabel.isHidden = votedStar == nil
        }
    }
    
    var votedCount: String? {
        didSet {
            votedCountLabel.text = votedCount
            votedCountLabel.isHidden = votedCount == nil
        }
    }
}

// MARK: - Public

extension SafeFoodHotItem {
    func setupData() {
        let mockUrl = "https://cdn.sforum.vn/sforum/wp-content/uploads/2022/04/15-7-scaled-e1650708800882.jpg"
        hotImageView.setImage(with: mockUrl, placeholderImage: nil)

    }
}
