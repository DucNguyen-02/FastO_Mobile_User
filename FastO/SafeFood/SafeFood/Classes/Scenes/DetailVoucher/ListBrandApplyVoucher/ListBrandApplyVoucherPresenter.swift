//
//  ListBrandApplyVoucherPresenter.swift
//  SafeFood
//
//  Created by Zipris on 28/11/2022.
//  
//

import Foundation

final class ListBrandApplyVoucherPresenter {
    
    // MARK: - Public Variable
    
    var brands: [BrandModel] = []
    weak var view: ListBrandApplyVoucherViewInput?
}

// MARK: - ListBrandApplyVoucherViewOutput

extension ListBrandApplyVoucherPresenter: ListBrandApplyVoucherViewOutput {
    func onViewDidLoad() {
        listBrand()
    }
}

// MARK: - Private

private extension ListBrandApplyVoucherPresenter {
    func listBrand() {
        BrandService.shared.getAllShop { [weak self] result in
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
