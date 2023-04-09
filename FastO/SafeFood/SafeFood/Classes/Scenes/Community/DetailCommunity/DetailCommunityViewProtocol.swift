//
//  DetailCommunityViewProtocol.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/13/22.
//  
//

import Foundation

protocol DetailCommunityDelegate: AnyObject {
    func likeReview()
    func likeComment(id: Int)
    func editPopupView(type: EditViewType, commentId: Int?)
    func updateReview()
    func deletePopView(type: EditViewType, commentId: Int?)
    func deleteAction(type: EditViewType, commentId: Int?)
}

protocol DetailCommunityViewInput: AnyObject {
    func reloadTableViewData()
    func popViewController()
}

protocol DetailCommunityViewOutput: AnyObject {
    func onViewDidLoad(id: Int)
    func onPostComment(id: Int, content: String)
    func onLikeReview(id: Int)
    func onLikeComment(reviewId: Int, id: Int)
    func onDeleteReview(id: Int)
    func onDeleteComment(reviewId: Int, id: Int)
}

enum DetailCommunitySection: Int, CaseIterable {
    case post = 0
    case commentPost
}
