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

    func onPostCart(_ params: [String: Any]) {
        postCart(params: params)
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

    func postCart(params: [String: Any]) {
        BillService.shared.postCart(params) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
