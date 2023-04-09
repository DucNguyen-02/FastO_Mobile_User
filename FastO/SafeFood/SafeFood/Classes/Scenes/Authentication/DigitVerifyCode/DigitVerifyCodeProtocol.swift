import Foundation

enum VerifyCodeType: Int, CaseIterable {
    case login
    case signUp
    case forgotPassword
}

protocol DigitVerifyCodeViewInput: AnyObject, CanNavigateViewControllers, CanShowLoadingProgress {
    func dismiss(isForgotPassword: Bool,_ authenToken: String?)
}

protocol DigitVerifyCodeViewOutput: AnyObject {
    func digitCodeActive(_ code: String)
    func resendDigitCodeActive(_ email: String)
    func digitCodeForgotPassword(_ code: String)
    func resendCodeForgotPassword(_ email: String)
}
