//
//  ShopCommunityPresenter.swift
//  SafeFood
//
//  Created by Zipris on 24/11/2022.
//  
//

import Foundation

final class ShopCommunityPresenter {
    
    // MARK: - Public Variable
    
    var brands: [BrandModel] = []
    weak var view: ShopCommunityViewInput?
}

// MARK: - ShopCommunityViewOutput

extension ShopCommunityPresenter: ShopCommunityViewOutput {
    func onViewDidLoad() {
        BrandService.shared.getAllShop { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case let .success(brands):
                self.brands = brands
                
                self.view?.reloadCollectionViewData()
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
