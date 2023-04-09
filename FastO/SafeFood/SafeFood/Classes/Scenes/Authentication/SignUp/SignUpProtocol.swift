import Foundation

protocol SignUpDelegate: AnyObject {
    func chooseDate(date: Date)
    func successVerify()
}

protocol SignUpViewInput: AnyObject, CanNavigateViewControllers, CanShowLoadingProgress {
    func digitVerifyCodePopup()
}

protocol SignUpViewOutput: AnyObject {
    func onSignUpButtonTapped(with validator: SignUpValidator)
}
