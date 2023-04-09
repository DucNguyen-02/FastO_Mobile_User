//
//  DetailCommunityPresenter.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/13/22.
//  
//

import Foundation

final class DetailCommunityPresenter {
    
    // MARK: - Private Variable
    
    
    private let group = DispatchGroup()
    
    // MARK: - Public Variable
    
    var community: DetailCommunityModel?
    weak var view: DetailCommunityViewInput?
}

// MARK: - DetailCommunityViewOutput

extension DetailCommunityPresenter: DetailCommunityViewOutput {
    func onViewDidLoad(id: Int) {
        getDetailCommunity(id: id)
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadTableViewData()
        }
    }
    
    func onPostComment(id: Int, content: String) {
        postComment(id: id, content: content)
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadTableViewData()
        }
    }
    
    func onLikeReview(id: Int) {
        postLikeReview(id: id)
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadTableViewData()
        }
    }
    
    func onLikeComment(reviewId: Int, id: Int) {
        postLikeComment(reviewId: reviewId, id: id)
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadTableViewData()
        }
    }
    
    func onDeleteReview(id: Int) {
        deleteReview(id: id)
    }
    
    func onDeleteComment(reviewId: Int, id: Int) {
        deleteComment(reviewId: reviewId, id: id)
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadTableViewData()
        }
    }
}

private extension DetailCommunityPresenter {
    func getDetailCommunity(id: Int) {
        group.enter()
        CommunityService.shared.getDetailCommunity(id: id) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(community):
                self.community = community
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func postComment(id: Int, content: String) {
        group.enter()
        CommunityService.shared.postCreateComment(id: id, content) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case .success:
                self.getDetailCommunity(id: id)
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
   
    func postLikeReview(id: Int) {
        group.enter()
        CommunityService.shared.postLikeReview(id: id) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case .success:
                self.getDetailCommunity(id: id)
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func postLikeComment(reviewId: Int, id: Int) {
        group.enter()
        CommunityService.shared.postLikeComment(id: id) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case .success:
                self.getDetailCommunity(id: reviewId)
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func deleteReview(id: Int) {
        CommunityService.shared.deleteReview(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view?.popViewController()
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func deleteComment(reviewId: Int, id: Int) {
        group.enter()
        CommunityService.shared.deleteComment(id: id) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case .success:
                self.getDetailCommunity(id: reviewId)
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
}
