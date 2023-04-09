import Foundation
import SVProgressHUD

final class DetailProductPresenter: DetailProductViewOutput {

    // MARK: - Public Variable

    var product: ProductModel?
    weak var view: DetailProductViewInput?
}

// MARK: - Public

extension DetailProductPresenter {
    func onViewDidLoad(with productId: Int) {
        getDetailProduct(productId)
    }
}

// MARK: - Private

private extension DetailProductPresenter {
    func getDetailProduct(_ productId: Int) {
        ProductService.shared.getDetailProduct(id: productId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(product):
                self.product = product
                self.view?.reloadData()
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
}
