//
//  CommunityViewProtocol.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 10/8/22.
//  
//

import Foundation

protocol ListCommunityDelegate: AnyObject {
    func chooseShop(id: Int?, indexPath: IndexPath)
    func reloadView()
    func likeReview(id: Int)
    func editPopupView(reviewId: Int)
    func deletePopView(reviewId: Int)
    func updateReview(reviewId: Int)
    func deleteReview(reviewId: Int)
}

protocol ListCommunityViewInput: AnyObject {
    func reloadTableViewData()
}

protocol ListCommunityViewOutput: AnyObject {
    func onViewDidLoad(id: Int?)
    func onLikeReview(shopId: Int?, id: Int)
    func onDeleteReview(shopId: Int?, id: Int)
}
