//
//CommentDetailCommunityCell.swift
//  SafeFood
//
//Created by Lê Kim Hoàng on 11/13/22.
//

import UIKit
class CommentDetailCommunityCell: UITableViewCell {

    @IBOutlet private weak var editButton: BaseButton!
    @IBOutlet private weak var avatarImageView: BaseImageView!
    @IBOutlet private weak var likeImageView: BaseImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var contentCommentLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var quantityLikeLabel: UILabel!
    @IBOutlet private weak var quantityLikeView: UIStackView!
    @IBOutlet private weak var likeButton: BaseButton!

    
    
    // MARK: - Private Variable
    
    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private var isLike: Bool = false
    private var comment: CommentCommunityModel?

    // MARK: - Public Variable
    
    weak var delegate: DetailCommunityDelegate?
    
    // MARK: - IBAction

    @IBAction private func likeButtonTapped(_ sender: Any) {
        isLike.toggle()
        guard let comment = comment else { return }
        likeImageView.image = isLike ? R.image.communitySelectedLike() : R.image.communitLike()
        likeLabel.textColor = isLike ? R.color.blue4789FA() : R.color.grayA2A2A3()
        quantityLikeView.isHidden = comment.totalFavorite < 1
        quantityLikeLabel.text = "\(comment.totalFavorite)"
        delegate?.likeComment(id: comment.id)
    }
    
    @IBAction private func editButtonTapped(_ sender: Any) {
        guard let comment = comment else { return }
        delegate?.editPopupView(type: .comment, commentId: comment.id)
    }
}

// MARK: - Public

extension CommentDetailCommunityCell {
    func setupData(comment: CommentCommunityModel) {
        self.isLike = comment.isLiked
        self.comment = comment
        guard let id = defaultsStorage.id else { return }
        editButton.isHidden = id != comment.user.id
        avatarImageView.setImage(with: comment.user.image, placeholderImage: R.image.icPlaceholderImg())
        avatarImageView.setCornerDefaultStyle()
        nameLabel.text = comment.user.name
        contentCommentLabel.text = comment.content
        likeImageView.image = comment.isLiked ? R.image.communitySelectedLike() : R.image.communitLike()
        likeLabel.textColor = comment.isLiked ? R.color.blue4789FA() : R.color.grayA2A2A3()
        quantityLikeView.isHidden = comment.totalFavorite < 1
        quantityLikeLabel.text = "\(comment.totalFavorite)"
        
        timeLabel.text = comment.modifiedAt
    }
}
