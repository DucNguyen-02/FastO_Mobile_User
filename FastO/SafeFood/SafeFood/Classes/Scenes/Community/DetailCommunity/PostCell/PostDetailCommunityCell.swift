//
//  PostDetailCommunityCell.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/13/22.
//

import UIKit

final class PostDetailCommunityCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var editButton: BaseButton!
    @IBOutlet private weak var avatarImageView: BaseImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var bannerView: SafeFoodBannerView!
    @IBOutlet private weak var quantityLikeLabel: UILabel!
    @IBOutlet private weak var likeImageView: UIImageView!
    @IBOutlet private weak var likeButton: BaseButton!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var commentImageView: UIImageView!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var commentButton: BaseButton!
    @IBOutlet private weak var quantityLikeView: UIView!
    
    // MARK: - Private Variable
    
    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private var isLike: Bool = false
    private var community: DetailCommunityModel?
    
    // MARK: - Public Variable
    
    weak var delegate: DetailCommunityDelegate?
    
    // MARK: - IBAction
    
    @IBAction private func likeButtonTapped(_ sender: Any) {
        isLike.toggle()

        guard let community = community else { return }
        likeImageView.image = isLike ? R.image.communitySelectedLike() : R.image.communitLike()
        likeLabel.textColor = isLike ? R.color.blue4789FA() : R.color.grayA2A2A3()
        if community.totalFavorite <= 1 {
            quantityLikeLabel.text = isLike ? "You" : "0"
        } else {
            quantityLikeLabel.text = isLike ? "You and \(community.totalFavorite - 1) orthers" : "\(community.totalFavorite)"
        }
        delegate?.likeReview()
    }
    
    @IBAction private func editButtonTapped(_ sender: Any) {
        delegate?.editPopupView(type: .review, commentId: nil)
    }
}

// MARK: - Public

extension PostDetailCommunityCell {
    func setupData(community: DetailCommunityModel) {
        self.community = community
        self.isLike = community.isLiked
        guard let id = defaultsStorage.id else { return }
        editButton.isHidden = id != community.user.id
        avatarImageView.setImage(with: community.user.image, placeholderImage: R.image.icPlaceholderImg())
        avatarImageView.setCornerDefaultStyle()
        nameLabel.text = community.user.name
        titleLabel.text = community.title
        contentLabel.text = community.content
        bannerView.update(with: community.images)
        likeImageView.image = community.isLiked ? R.image.communitySelectedLike() : R.image.communitLike()
        likeLabel.textColor = community.isLiked ? R.color.blue4789FA() : R.color.grayA2A2A3()
        if community.totalFavorite <= 1 {
            quantityLikeLabel.text = isLike ? "You" : "0"
        } else {
            quantityLikeLabel.text = isLike ? "You and \(community.totalFavorite - 1) orthers" : "\(community.totalFavorite)"
        }
        
        timeLabel.text = community.createdAt
    }
}
