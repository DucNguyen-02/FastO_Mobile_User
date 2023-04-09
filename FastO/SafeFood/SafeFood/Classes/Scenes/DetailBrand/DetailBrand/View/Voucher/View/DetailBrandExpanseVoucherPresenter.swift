//
//  DetailBrandExpanseVoucherPresenter.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/17/22.
//

import Foundation


final class DetailBrandExpanseVoucherPresenter {

    // MARK: - Public Variable

    var vouchers: [VoucherModel] = []
    weak var view: DetailBrandExpanseVoucherViewInput?
}

// MARK: - DetailVoucherViewOutput

extension DetailBrandExpanseVoucherPresenter: DetailBrandExpanseVoucherViewOutput {
    func onViewDidLoad(with id: Int) {
        getListVoucherShop(id: id)
    }
}

// MARK: - Private

private extension DetailBrandExpanseVoucherPresenter {
    func getListVoucherShop(id: Int) {
        VoucherService.shared.getListVoucherShop(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(vouchers):
                self.vouchers = vouchers
                self.view?.reloadData()
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
