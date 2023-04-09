//
//  ListCommunityViewController.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 10/8/22.
//  
//

import UIKit
import STPopup

final class ListCommunityViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var listShopView: CommunityShopView!
    @IBOutlet private weak var tableView: BaseTableView!
    
    // MARK: - Private Variable
    
    private var shopId: Int?
    private var shopIndex: IndexPath = IndexPath(row: 0, section: 0)
    private var editViewController: STPopupController!
    private var confirmViewController: STPopupController!
    private lazy var presenter: ListCommunityPresenter = {
      let presenter = ListCommunityPresenter()
      presenter.view = self
      return presenter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.onViewDidLoad(id: nil)
    }
}

// MARK: - Private

private extension ListCommunityViewController {
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommunityCell.self)
        tableView.register(NewCommunityCell.self)
    }
    
    func showEditViewPopup(reviewId: Int) {
        guard let topVC = UIViewController.topViewController else {return}

        let vc = EditCommunityViewController()
        vc.reviewId = reviewId
        vc.delegate = self
        vc.type = .review
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

    func showConfirmPopup(reviewId: Int) {
        guard let topVC = UIViewController.topViewController else {return}

        let vc = ConfirmCommunityViewController()
        vc.delegate = self
        vc.type = .review
        vc.reviewId = reviewId
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

// MARK: - UITableViewDataSource

extension ListCommunityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.community.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeue(NewCommunityCell.self)
            return cell
        } else {
            let cell = tableView.dequeue(CommunityCell.self)
            cell.delegate = self
            cell.setupData(community: presenter.community[indexPath.row - 1])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ListCommunityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let topVC = UIViewController.topViewController() {
                let vc = CreateCommunityViewController.makeMe()
                vc.type = .new
                topVC.pushViewController(vc, with: .moveInFromBottom)
            }
        } else {
            if let topVC = UIViewController.topViewController() {
                let vc = DetailCommunityViewController.makeMe()
                vc.delegate = self
                vc.setupData(id: presenter.community[indexPath.row - 1].id)
                topVC.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - ListCommunityDelegate

extension ListCommunityViewController: ListCommunityDelegate {
    func chooseShop(id: Int?, indexPath: IndexPath) {
        self.shopIndex = indexPath
        self.shopId = id
        tableView.scrollToTop()
        presenter.onViewDidLoad(id: id)
    }
    
    func reloadView() {
        tableView.scrollToTop()
        presenter.onViewDidLoad(id: shopId)
    }
    
    func likeReview(id: Int) {
        presenter.onLikeReview(shopId: shopId, id: id)
    }
    
    func editPopupView(reviewId: Int) {
        showEditViewPopup(reviewId: reviewId)
    }
    
    func deletePopView(reviewId: Int) {
        showConfirmPopup(reviewId: reviewId)
    }

    func updateReview(reviewId: Int) {
        if let topVC = UIViewController.topViewController() {
            let vc = CreateCommunityViewController.makeMe()
            vc.type = .update
            vc.setupData(id: reviewId)
            topVC.pushViewController(vc, with: .moveInFromBottom)
        }
    }
    
    func deleteReview(reviewId: Int) {
        presenter.onDeleteReview(shopId: shopId, id: reviewId)
    }

}

// MARK: - ListCommunityViewInput

extension ListCommunityViewController: ListCommunityViewInput {
    func reloadTableViewData() {
        listShopView.setupData(with: presenter.brands)
        listShopView.delegate = self
        listShopView.selectedShop = shopIndex
        tableView.reloadData()
    }
}
