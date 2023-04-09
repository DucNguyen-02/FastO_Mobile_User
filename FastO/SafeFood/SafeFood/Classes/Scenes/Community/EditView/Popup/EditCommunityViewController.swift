//
//  EditCommunityViewController.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/14/22.
//

import UIKit

enum EditViewType: Int, CaseIterable {
    case review = 0
    case comment
}

final class EditCommunityViewController: BaseViewController {

    struct Constants {
        static let designViewSize = CGSize(width: 375, height: 120)
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

    @IBOutlet private weak var deleteButton: BaseButton!
    @IBOutlet private weak var editButton: BaseButton!

    // MARK: - Public Variable

    var type: EditViewType = .review
    var reviewId: Int?
    var commentId: Int?
    var isDetail: Bool = false
    weak var delegate: ListCommunityDelegate?
    weak var detailDelegate: DetailCommunityDelegate?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.isHidden = type == .comment
        deleteButton.setTitle("Delete", for: .normal)
        editButton.setTitle("Edit", for: .normal)
    }
    
    // MARK: - IBAction

    @IBAction private func deleteButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            if self.isDetail {
                switch self.type {
                case .review:
                    self.detailDelegate?.deletePopView(type: .review, commentId: nil)
                case .comment:
                    guard let commentId = self.commentId else { return }
                    self.detailDelegate?.deletePopView(type: .comment, commentId: commentId)
                }
            } else {
                guard let reviewId = self.reviewId else { return }
                self.delegate?.deletePopView(reviewId: reviewId)
            }
        }
    }

    @IBAction private func editButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            if self.isDetail {
                self.detailDelegate?.updateReview()
            } else {
                guard let reviewId = self.reviewId else { return }
                self.delegate?.updateReview(reviewId: reviewId)
            }
        }
    }
}
