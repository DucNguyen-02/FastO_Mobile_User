import Foundation

protocol ResetPasswordViewInput: AnyObject, CanNavigateViewControllers, CanShowLoadingProgress {}

protocol ResetPasswordViewOutput: AnyObject {
    func onResetPasswordButtonTapped(authToken: String, with Validator: ResetPasswordValidator)
}
