import UIKit
import SVProgressHUD

final class DetailBillPresenter {
    struct Constants {
        static let statusSuccess: String = "00"
        static let statusReSuccess: String = "02"
    }
    
    // MARK: - Lifecycle
    
    init() {
        setupNotification()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Private Variable
    
    private var group = DispatchGroup()
    private let notificationCenter: NotificationCenterService = NotificationCenter.default
    private var orderId: Int?
    
    // MARK: - Public Variable
    
    var order: DetailBillModel?
    weak var view: DetailBillViewInput?
}

// MARK: - Public

extension DetailBillPresenter: DetailBillViewOutput {
    func onViewDidLoad(id: Int, isShowQR: Bool) {
        self.orderId = id
        getOrderDetail(id, isShowQR: isShowQR)
        
        group.notify(queue: .main) { [weak self] in
            if isShowQR {
                self?.view?.showPopupQRCode()
            }
            self?.view?.reloadTableViewData()
        }
    }
}

// MARK: - Public

extension DetailBillPresenter {
    func onOrderButtonTappedWithVnPay(requestModel: VNPaymentRequestModel) {
        SVProgressHUD.show()
        PaymentService.shared.vnPayMethod(requestModel: requestModel) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let url):
                UIApplication.openURL(URL(string: url))
                
            case .failure(let error):
                ToastHelper.showToast(error.message)
            }
        }
    }
}

// MARK: - Private

private extension DetailBillPresenter {
    func setupNotification() {
        notificationCenter.addObserver(self, forName: PaymentNotification.paymentVNPayCompleted) { [weak self] notification in
            if let requestModel = notification.object as? VNPaymentResultRequestModel {
                self?.getVNPayTransactionResult(requestModel)
            }
        }
    }
    
    func getOrderDetail(_ orderId: Int, isShowQR: Bool) {
        group.enter()
        BillService.shared.getDetailBill(id: orderId) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(orderDetail):
                self.order = orderDetail
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func getVNPayTransactionResult(_ requestModel: VNPaymentResultRequestModel) {
        PaymentService.shared.getVNPaymentResult(requestModel: requestModel) { result in
            switch result {
            case .success(let response):
                if response.responseCode == Constants.statusSuccess || response.responseCode == Constants.statusReSuccess {
                    ToastHelper.showToast("SUCCESS")
                    self.onViewDidLoad(id: self.orderId.orEmpty, isShowQR: true)
                } else {
                    ToastHelper.showToast(response.message)
                }
            case .failure(let error):
                ToastHelper.showToast(error.message)
            }
        }
    }
}

