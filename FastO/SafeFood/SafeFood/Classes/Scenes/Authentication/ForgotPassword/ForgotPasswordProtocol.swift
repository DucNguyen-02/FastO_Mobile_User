import Foundation

protocol ForgotPasswordDelegate: AnyObject {
    func resetPassword(authToken: String)
}

protocol ForgotPasswordViewInput: AnyObject, CanNavigateViewControllers, CanShowLoadingProgress {
    func showDigitVerifyCodePopup()
}

protocol ForgotPasswordViewOutput: AnyObject {
    func forgotPasswordByEmail(_ email: String)
}
