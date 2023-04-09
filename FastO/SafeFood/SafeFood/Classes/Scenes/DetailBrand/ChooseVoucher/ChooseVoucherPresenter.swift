//
//  ChooseVoucherPresenter.swift
//  SafeFood
//
//  Created by ADMIN on 19/11/2022.
//  
//

import Foundation

final class ChooseVoucherPresenter {
    
    // MARK: - Public Variable
    
    var vouchers: [VoucherModel] = []
    weak var view: ChooseVoucherViewInput?
}

// MARK: - ChooseVoucherViewOutput

extension ChooseVoucherPresenter: ChooseVoucherViewOutput {
    func onViewDidLoad(_ params: [String: Any]) {
        postVoucherApply(params)
    }
    
    func onCreateBill(_ params: [String : Any]) {
        postBill(params)
    }
}

// MARK: - Private

private extension ChooseVoucherPresenter {
    func postVoucherApply(_ params: [String: Any]) {
        VoucherService.shared.postVoucherApply(params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(vouchers):
                self.vouchers = vouchers
                self.view?.reloadTableViewData()
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
    
    func postBill(_ params: [String: Any]) {
        BillService.shared.postBill(params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(billId):
                self.view?.moveDetailOrder(billId: billId)
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
