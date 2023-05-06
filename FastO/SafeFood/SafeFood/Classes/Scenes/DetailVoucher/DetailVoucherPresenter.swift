import Foundation

final class DetailVoucherPresenter {
    
    // MARK: - Public Variable

    var voucher: VoucherModel?
    weak var view: DetailVoucherViewInput?
}

// MARK: - DetailVoucherViewOutput

extension DetailVoucherPresenter: DetailVoucherViewOutput {
    func onViewDidLoad(id: Int) {
        getDetailVoucher(id: id)
    }
}

// MARK: - Private

private extension DetailVoucherPresenter {
    func getDetailVoucher(id: Int) {
        VoucherService.shared.getDetailVoucher(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(voucher):
                self.voucher = voucher
                self.view?.reloadData()
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
