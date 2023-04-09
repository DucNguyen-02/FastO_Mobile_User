//
//  MenuBrandPresenter.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/18/22.
//  
//

import Foundation

final class MenuBrandPresenter {
    
    // MARK: - Public Variable

    var products: [ProductModel] = []
    var vouchers: [VoucherModel] = []
    weak var view: MenuBrandViewInput?
}

// MARK: - MenuBrandViewOutput

extension MenuBrandPresenter: MenuBrandViewOutput {
    func onViewDidLoad(shopId: Int) {
        getMenuProduct(id: shopId)
    }
}

// MARK: - Private

private extension MenuBrandPresenter {
    func getMenuProduct(id: Int) {
        ProductService.shared.getProductMenu(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(products):
                self.products = products
                self.view?.reloadTableViewData()
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
