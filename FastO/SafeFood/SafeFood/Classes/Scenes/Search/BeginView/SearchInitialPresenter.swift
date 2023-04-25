import Foundation
import SVProgressHUD

final class SearchInitialPresenter: SearchInitialViewOutput {

    // MARK: - Private Variable

    private let group = DispatchGroup()

    // MARK: - Public Variable
    
    var brands: [BrandModel] = []
    var hotVouchers: [VoucherModel] = []
    weak var view: SearchInitialViewInput?
}

// MARK: - Public

extension SearchInitialPresenter {
    func onViewDidLoad(_ latitude: Double, _ longitude: Double) {
        getHotVouchers()
        getNearLoaction(latitude,longitude)
//
        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadTableViewData()
        }
    }
}

// MARK: - Private

extension SearchInitialPresenter {
    func getNearLoaction(_ latitude: Double, _ longitude: Double) {
        group.enter()
        LocationService.shared.getListBrandLocation(latitude, longitude) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(listBrandLocation):
                self.brands = listBrandLocation
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
    
    func getHotVouchers() {
        group.enter()
        VoucherService.shared.getAllVoucher(type: .shop) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(hotVouchers):
                self.hotVouchers = hotVouchers
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
