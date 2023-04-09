//
//  HomeRecentBrandPresenter.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/18/22.
//

import Foundation
import SVProgressHUD

final class HomeRecentBrandPresenter: HomeRecentBrandViewOutput {

    // MARK: - Public Variable

    weak var view: HomeRecentBrandViewInput?

    func onViewDidLoad(id: Int) {
        postRecentBrand(id: id)
    }
}

// MARK: - Private

private extension HomeRecentBrandPresenter {
    func postRecentBrand(id: Int) {
        BrandService.shared.postRecentBrand(id: id) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
