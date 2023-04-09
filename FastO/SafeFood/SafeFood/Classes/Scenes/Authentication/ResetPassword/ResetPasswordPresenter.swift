import Foundation

final class ResetPasswordPresenter: ResetPasswordViewOutput {

    // MARK: - Public Variable

    weak var view: ResetPasswordViewInput?

    func onResetPasswordButtonTapped(authToken: String, with validator: ResetPasswordValidator ) {
        if let error = validateResetPasswordInput(with: validator) {
            ToastHelper.showError(error)
            return
        }

        view?.startLoading()
        AuthenService.shared.resetPassword(authToken, password: validator.password) { [weak self] result in
            self?.view?.finishLoading()
            switch result {
            case .success:
                self?.view?.popToRootViewController(animated: true)
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}

// MARK: - Private

private extension ResetPasswordPresenter {
    func validateResetPasswordInput(with validator: ResetPasswordValidator) -> String? {
        guard validator.isValidPassword(),
              validator.isValidRepeatPassword()
        else {
            return R.string.localizable.sign_up_error.localized()
        }
        return nil
    }
}
