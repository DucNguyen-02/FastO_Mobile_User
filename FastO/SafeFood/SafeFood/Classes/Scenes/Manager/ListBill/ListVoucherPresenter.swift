import UIKit
import SVProgressHUD

final class ListVoucherPresenter: ListVoucherViewOutput {
    
    // MARK: - Public Variable
    
    var savedBrands: [BrandFavouriteModel] = []
    var listBill: [ListBillModel] = []

    
    weak var view: ListVoucherViewInput?
    
    func getDataOrder(status: BillStatus, query: String?) {
        getListBill(status: status, query: query)
    }
    
    func getDataSavedBrands() {
        getSavedBrands()
    }
}

// MARK: - Private

private extension ListVoucherPresenter {
    func getSavedBrands() {
        BrandService.shared.getListBrandFavourite { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(savedBrands):
                self.savedBrands = savedBrands
                self.view?.reloadTableviewData()
                
            case let .failure(error):
                ToastHelper.showError(error.message)

            }
        }
    }
    
    func getListBill(status: BillStatus, query: String?) {
        BillService.shared.getListBill(status: status.rawValue, query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(bill):
                self.listBill = bill
                self.view?.reloadTableviewData()
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
        
