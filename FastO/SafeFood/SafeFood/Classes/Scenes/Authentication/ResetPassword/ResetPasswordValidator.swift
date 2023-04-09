import Foundation

struct ResetPasswordValidator {
    let password: String
    let confirmPassword: String
}

extension ResetPasswordValidator {
    func isValidPassword() -> Bool {
        return password.isNotEmpty
    }

    func isValidRepeatPassword() -> Bool {
        return confirmPassword.isNotEmpty && password == confirmPassword
    }
}
