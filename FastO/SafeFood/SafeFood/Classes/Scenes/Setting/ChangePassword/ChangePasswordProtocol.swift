import Foundation

protocol ChangePasswordViewInput: AnyObject {
    func successView()
}

protocol ChangePasswordViewOutput: AnyObject {
    func onDidViewLoad(_ change: ChangePasswordModel)
}

