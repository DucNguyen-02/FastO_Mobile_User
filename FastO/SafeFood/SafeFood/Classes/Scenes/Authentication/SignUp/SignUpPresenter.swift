import Foundation

final class SignUpPresenter: SignUpViewOutput {

    // MARK: - Public Variable

    weak var view: SignUpViewInput?

    func onSignUpButtonTapped(with validator: SignUpValidator) {
        if let error = validateSignUpInput(with: validator) {
            view?.showError(error)
            return
        }

        view?.startLoading()
        AuthenService.shared.signUpEmail(validator.toDict()) { [weak self] result in
            self?.view?.finishLoading()

            switch result {
            case .success:
                self?.view?.digitVerifyCodePopup()

            case let .failure(error):
                self?.view?.showError(error.message)
            }
        }
    }
}

// MARK: - Private

private extension SignUpPresenter {
    func validateSignUpInput(with validator: SignUpValidator) -> String? {
        guard validator.isValidName() else {
            return R.string.localizable.sign_up_error.localized()
        }
        guard validator.isValidDateOfBirth() else {
            return R.string.localizable.sign_up_error.localized()
        }
        guard validator.isValidPhone() else {
            return R.string.localizable.sign_up_error.localized()
        }
        guard validator.isValidEmail() else {
            return R.string.localizable.sign_up_error.localized()
        }
        guard validator.isValidPassword() else {
            return R.string.localizable.sign_up_error.localized()
        }
        guard validator.isValidRepeatPassword() else {
            return R.string.localizable.sign_up_error.localized()
        }
        guard validator.isBothPasswordsMatch() else {
            return R.string.localizable.sign_up_error.localized()
        }
        guard validator.isAcceptTermAndPolicy else {
            return R.string.localizable.sign_up_need_accept_term_and_policy.localized()
        }
        return nil
    }
}
