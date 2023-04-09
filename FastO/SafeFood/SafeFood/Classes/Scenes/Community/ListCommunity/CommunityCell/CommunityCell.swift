//
//  CommunityCell.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/13/22.
//

import UIKit

final class CommunityCell: UITableViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var editButton: BaseButton!
    @IBOutlet private weak var avatarImageView: BaseImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var bannerView: SafeFoodBannerView!
    @IBOutlet private weak var quantityLikeLabel: UILabel!
    @IBOutlet private weak var quantityCommentLabel: UILabel!
    @IBOutlet private weak var likeImageView: UIImageView!
    @IBOutlet private weak var likeButton: BaseButton!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var commentImageView: UIImageView!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var likeView: UIStackView!
    @IBOutlet private weak var commentButton: BaseButton!

    // MARK: - Private Variable
    
    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private var community: CommunityModel?
    private var isLike: Bool = false
    
    // MARK: - Public Variable
    
    weak var delegate: ListCommunityDelegate?
    
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
        delegate?.likeReview(id: community.id)
    }

    @IBAction private func editButtonTapped(_ sender: Any) {
        guard let community = community else { return }
        delegate?.editPopupView(reviewId: community.id)
    }
}

// MARK: - Public

extension CommunityCell {
    func setupData(community: CommunityModel) {
        self.community = community
        self.isLike = community.isLiked
        avatarImageView.setImage(with: community.user.image, placeholderImage: R.image.icPlaceholderImg())
        avatarImageView.setCornerDefaultStyle()
        nameLabel.text = community.user.name
        titleLabel.text = community.title
        contentLabel.text = community.content
        bannerView.update(with: community.images)
        quantityLikeLabel.text = "\(community.totalFavorite)"
        if community.totalComment < 2 {
            quantityCommentLabel.text = "\(community.totalComment) Comment"
        } else {
            quantityCommentLabel.text = "\(community.totalComment) Comments"
        }
        
        likeImageView.image = community.isLiked ? R.image.communitySelectedLike() : R.image.communitLike()
        likeLabel.textColor = community.isLiked ? R.color.blue4789FA() : R.color.grayA2A2A3()
        
        guard let id = defaultsStorage.id else { return }
        editButton.isHidden = id != community.user.id
    }
}
