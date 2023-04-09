import Foundation

final class ForgotPasswordPresenter: ForgotPasswordViewOutput {

    // MARK: - Public Variable

    weak var view: ForgotPasswordViewInput?

    func forgotPasswordByEmail(_ email: String) {
        if !email.isEmail() {
            ToastHelper.showError(R.string.localizable.sign_in_email_error.localized())
            return
        }

        view?.startLoading()
        AuthenService.shared.forgotPassword(email) { [weak self] result in
            self?.view?.finishLoading()
            switch result {
            case .success:
                self?.view?.showDigitVerifyCodePopup()

            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
