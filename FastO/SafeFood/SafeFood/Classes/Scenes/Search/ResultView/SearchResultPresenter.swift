import Foundation
import SVProgressHUD

final class SearchResultPresenter: SearchResultViewOutput {

    // MARK: - Private Variable

    private let group = DispatchGroup()

    // MARK: - Public Variable

    var brands: [BrandModel] = []
    var products: [ProductModel] = []
    var vouchers: [VoucherModel] = []
    weak var view: SearchResultViewInput?
}

// MARK: - Public

extension SearchResultPresenter {
    func onViewDidLoad(with keyword: String) {
        getVoucherSearch(keyword)
        getBrandSearch(keyword)

        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadTableViewData()
        }
    }
}

// MARK: - Private

extension SearchResultPresenter {
    func getVoucherSearch(_ keyword: String) {
        group.enter()
        SearchService.shared.searchVoucher(keyword: keyword) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(vouchers):
                self.vouchers = vouchers

            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }

    func getBrandSearch(_ keyword: String) {
        group.enter()
        SearchService.shared.searchBrand(keyword: keyword) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(brands):
                self.brands = brands

            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
}
