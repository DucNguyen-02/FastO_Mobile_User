//
//  ListCommunityPresenter.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 10/8/22.
//  
//

import Foundation

final class ListCommunityPresenter {
    
    // MARK: - Private Variable
    
    private var group = DispatchGroup()
    
    // MARK: - Public Variable
    
    var brands: [BrandModel] = []
    var community: [CommunityModel] = []
    weak var view: ListCommunityViewInput?
}

// MARK: - ListCommunityViewOutput

extension ListCommunityPresenter: ListCommunityViewOutput {
    func onViewDidLoad(id: Int?) {
        getListShop()
        getListCommunity(id: id)
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadTableViewData()
        }
    }
    
    func onLikeReview(shopId: Int?, id: Int) {
        postLikeReview(shopId: shopId, id: id)
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadTableViewData()
        }
    }
    
    func onDeleteReview(shopId: Int?, id: Int) {
        deleteReview(shopId: shopId, id: id)
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadTableViewData()
        }
    }

}

// MARK: - Private

private extension ListCommunityPresenter {
    func getListCommunity(id: Int?) {
        group.enter()
        CommunityService.shared.getListCommunity(id: id) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(community):
                self.community = community
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
    
    func getListShop() {
        group.enter()
        BrandService.shared.getAllShop { [weak self]  result in
            defer { self?.group.leave() }

            guard let self = self else { return }
            switch result {
            case let .success(brands):
                self.brands = brands
                
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
    
    
    func postLikeReview(shopId: Int?, id: Int) {
         group.enter()
         CommunityService.shared.postLikeReview(id: id) { [weak self] result in
             defer { self?.group.leave() }
             guard let self = self else { return }
             switch result {
             case .success:
                 self.getListCommunity(id: shopId)
                 
             case let .failure(error):
                 ToastHelper.showToast(error.message)
             }
         }
     }
     
    func deleteReview(shopId: Int?, id: Int) {
        group.enter()

         CommunityService.shared.deleteReview(id: id) { [weak self] result in
             defer { self?.group.leave() }

             guard let self = self else { return }
             switch result {
             case .success:
                 self.getListCommunity(id: shopId)

             case let .failure(error):
                 ToastHelper.showToast(error.message)
             }
         }
     }
}
