import Foundation

final class DigitVerifyCodePresenter: DigitVerifyCodeViewOutput {

    // MARK: - Private Variable

    private let defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private let notificationCenter: NotificationCenterService = NotificationCenter.default

    // MARK: - Public Variable

    weak var view: DigitVerifyCodeViewInput?

    func digitCodeActive(_ code: String) {
        view?.startLoading()
        AuthenService.shared.digitCodeActive(code) { [weak self] result in
            self?.view?.finishLoading()
            switch result {
            case .success:
                self?.notificationCenter.post(name: AccountNotifications.authorizationCompleted, object: nil)
                self?.view?.dismiss(isForgotPassword: false, nil)
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }

    func resendDigitCodeActive (_ email: String) {
        view?.startLoading()
        AuthenService.shared.resendDigitCodeActive(email) { [weak self] result in
            self?.view?.finishLoading()
            switch result {
            case .success:
                ToastHelper.showToast("Success")
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }

    func digitCodeForgotPassword(_ code: String) {
        view?.startLoading()
        AuthenService.shared.digitCodeForgotPassword(code) { [weak self] result in
            self?.view?.finishLoading()
            switch result {
            case .success:
                guard let authToken = self?.defaultsStorage.accessToken else { return }
                self?.view?.dismiss(isForgotPassword: true, authToken)
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }

    func resendCodeForgotPassword(_ email: String) {
        view?.startLoading()
        AuthenService.shared.forgotPassword(email) { [weak self] result in
            self?.view?.finishLoading()
            switch result {
            case .success:
                ToastHelper.showToast("Success")
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
