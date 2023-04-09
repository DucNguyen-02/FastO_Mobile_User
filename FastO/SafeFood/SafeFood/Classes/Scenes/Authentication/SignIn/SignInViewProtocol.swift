import UIKit

protocol SignInViewInput: AnyObject, CanNavigateViewControllers, CanShowLoadingProgress {
    var viewController: UIViewController { get }
    func showDigitVerifyCodePopup(email: String, type: VerifyCodeType)
}

protocol SignInViewOutput: AnyObject {
    func loginByEmail(with validator: SignInValidator)
    func loginByGoogle()
    func loginByFaceBook()
}
