//
//  DetailCommunityViewController.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/13/22.
//  
//

import UIKit
import STPopup

final class DetailCommunityViewController: BaseViewController {

    struct Constants {
        static let rowSection: Int = 1
        static let valuePost: Int = 0
        static let valueComment: Int = 1
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: BaseTableView!
    @IBOutlet private weak var avatarImageView: BaseImageView!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var postButton: BaseButton!

    // MARK: - Private Variable
    
    private var reviewId: Int?
    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private lazy var presenter: DetailCommunityPresenter = {
      let presenter = DetailCommunityPresenter()
      presenter.view = self
      return presenter
    }()
    
    // MARK: - Private Variable
    
    private var editViewController: STPopupController!
    private var confirmViewController: STPopupController!
    
    // MARK: - Public Variable
    
    weak var delegate: ListCommunityDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - IBAction

    @IBAction private func backButtonTapped(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction private func postButtonTapped(_ sender: Any) {
        guard let community = presenter.community else { return }
        presenter.onPostComment(id: community.id, content: commentTextField.text.orEmpty)
    }
}

// MARK: - Private

private extension DetailCommunityViewController {
    func setupUI() {
        tableView.register(PostDetailCommunityCell.self)
        tableView.register(CommentDetailCommunityCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func showEditViewPopup(type: EditViewType, commentId: Int?) {
        guard let topVC = UIViewController.topViewController else {return}

        let vc = EditCommunityViewController()
        vc.detailDelegate = self
        vc.isDetail = true
        
        switch type {
        case .review:
            guard let shopId = reviewId else { return }
            vc.type = .review
            vc.reviewId = shopId
            vc.commentId = nil
        case .comment:
            vc.type = .comment
            vc.reviewId = nil
            vc.commentId = commentId
        }
        vc.contentSizeInPopup = EditCommunityViewController.Constants.viewSize

        let popupController = STPopupController(rootViewController: vc)
        popupController.navigationBar.isHidden = true
        popupController.transitionStyle = .slideVertical
        popupController.containerView.layer.cornerRadius = 0
        popupController.containerView.backgroundColor = .clear
        popupController.safeAreaInsets.bottom = 0
        popupController.style = .bottomSheet
        popupController.backgroundView?.backgroundColor = R.color.black060606() ?? .black
        popupController.backgroundView?.alpha = 0.7
        popupController.present(in: topVC, completion: nil)

        editViewController = popupController
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editDidTapBackgroundView))
        editViewController.backgroundView?.addGestureRecognizer(tapGesture)
    }

    @objc func editDidTapBackgroundView() {
        editViewController.dismiss()
    }

    func showConfirmPopup(type: EditViewType, commentId: Int?) {
        guard let topVC = UIViewController.topViewController else {return}

        let vc = ConfirmCommunityViewController()
        vc.detailDelegate = self
        vc.isDetail = true
        switch type {
        case .review:
            guard let shopId = reviewId else { return }
            vc.type = .review
            vc.reviewId = shopId
            vc.commentId = nil
        case .comment:
            vc.type = .comment
            vc.reviewId = nil
            vc.commentId = commentId
        }
        vc.contentSizeInPopup = ConfirmCommunityViewController.Constants.viewSize

        let popupController = STPopupController(rootViewController: vc)
        popupController.navigationBar.isHidden = true
        popupController.transitionStyle = .slideVertical
        popupController.containerView.layer.cornerRadius = 0
        popupController.containerView.backgroundColor = .clear
        popupController.safeAreaInsets.bottom = 0
        popupController.style = .bottomSheet
        popupController.backgroundView?.backgroundColor = R.color.black060606() ?? .black
        popupController.backgroundView?.alpha = 0.7
        popupController.present(in: topVC, completion: nil)

        confirmViewController = popupController
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(confirmDidTapBackgroundView))
        confirmViewController.backgroundView?.addGestureRecognizer(tapGesture)
    }

    @objc func confirmDidTapBackgroundView() {
        confirmViewController.dismiss()
    }
}

// MARK: - Public

extension DetailCommunityViewController {
    func setupData(id: Int) {
        self.reviewId = id
        presenter.onViewDidLoad(id: id)
    }
}

// MARK: - UITableViewDataSource

extension DetailCommunityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailCommunitySection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = DetailCommunitySection(rawValue: section),
                let community = presenter.community else { return 0 }
        switch sectionType {
        case .post:
            return Constants.rowSection
        case .commentPost:
            return community.reply.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = DetailCommunitySection(rawValue: indexPath.section),
                let community = presenter.community else { return UITableViewCell() }
        switch sectionType {
        case .post:
            let cell = tableView.dequeue(PostDetailCommunityCell.self)
            cell.delegate = self
            cell.setupData(community: community)
            return cell
        case .commentPost:
            let cell = tableView.dequeue(CommentDetailCommunityCell.self)
            cell.delegate = self
            cell.setupData(comment: community.reply[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension DetailCommunityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - DetailCommunityDelegate

extension DetailCommunityViewController: DetailCommunityDelegate {
    func likeComment(id: Int) {
        guard let shopId = reviewId else { return }
        presenter.onLikeComment(reviewId: shopId, id: id)
    }
    
    func likeReview() {
        guard let shopId = reviewId else { return }
        presenter.onLikeReview(id: shopId)
    }
    
    func editPopupView(type: EditViewType, commentId: Int?) {
        showEditViewPopup(type: type, commentId: commentId)
    }
    
    func deletePopView(type: EditViewType, commentId: Int?) {
        showConfirmPopup(type: type, commentId: commentId)
    }

    func updateReview() {
        guard let reviewId = reviewId else { return }
        if let topVC = UIViewController.topViewController() {
            let vc = CreateCommunityViewController.makeMe()
            vc.type = .update
            vc.setupData(id: reviewId)
            topVC.pushViewController(vc, with: .moveInFromBottom)
        }
    }
    
    func deleteAction(type: EditViewType, commentId: Int?) {
        guard let shopId = reviewId else { return }
        switch type {
        case .review:
            presenter.onDeleteReview(id: shopId)
        case .comment:
            guard let commentId = commentId else { return }
            presenter.onDeleteComment(reviewId: shopId, id: commentId)
        }
    }
}

// MARK: - DetailCommunityViewInput

extension DetailCommunityViewController: DetailCommunityViewInput {
    func reloadTableViewData() {
        tableView.reloadData()
    }
    
    func popViewController() {
        delegate?.reloadView()
        popViewController(animated: true)
    }
}
