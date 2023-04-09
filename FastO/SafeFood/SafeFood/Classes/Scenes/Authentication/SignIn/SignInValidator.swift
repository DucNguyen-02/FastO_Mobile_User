import Foundation

struct SignInValidator {
    let email: String
    let password: String
}

extension SignInValidator {
    func isValidEmail() -> Bool {
        return email.isNotEmpty && email.isEmail()
    }

    func isValidPassword() -> Bool {
        return password.isNotEmpty
    }
}
