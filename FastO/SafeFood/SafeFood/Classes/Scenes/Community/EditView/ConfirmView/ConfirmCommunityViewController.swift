//
//  ConfirmCommunityViewController.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/14/22.
//

import UIKit

final class ConfirmCommunityViewController: BaseViewController {

    struct Constants {
        static let designViewSize = CGSize(width: 375, height: UIScreen.main.bounds.height)
        static let designScreenWidth: CGFloat = 375
        static var viewSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = screenWidth / designScreenWidth
            let viewWidth = designViewSize.width * ratio
            let viewHeight = designViewSize.height * ratio
            return CGSize(width: viewWidth, height: viewHeight)
        }()
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var notificationLabel: UILabel!
    @IBOutlet private weak var backButton: BaseButton!
    @IBOutlet private weak var deleteButton: BaseButton!

    // MARK: - Public Variable

    var type: EditViewType = .review
    var reviewId: Int?
    var commentId: Int?
    var isDetail: Bool = false
    weak var delegate: ListCommunityDelegate?
    weak var detailDelegate: DetailCommunityDelegate?

    // MARK: - IBAction

    @IBAction private func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction private func deleteButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            if self.isDetail {
                switch self.type {
                case .review:
                    self.detailDelegate?.deleteAction(type: .review, commentId: nil)
                case .comment:
                    guard let commentId = self.commentId else { return }
                    self.detailDelegate?.deleteAction(type: .comment, commentId: commentId)
                }
            } else {
                guard let reviewId = self.reviewId else { return }
                self.delegate?.deleteReview(reviewId: reviewId)
            }

        }
    }
}
