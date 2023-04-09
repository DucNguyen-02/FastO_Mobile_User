import Foundation

struct SignUpValidator {
    static let MinPhoneLength = 10

    let firstName: String
    let lastName: String
    let dateOfBirth: TimeInterval
    let phone: String
    let email: String
    let password: String
    let repeatPassword: String
    let isAcceptTermAndPolicy: Bool
}

extension SignUpValidator {
    func toDict() -> [String: Any] {
        return [
            "birthDay": dateOfBirth,
            "email": email,
            "firstname": firstName,
            "lastname": lastName,
            "password": password,
            "phoneNumber": phone
        ]
    }

    func isValidName() -> Bool {
        return firstName.isNotEmpty && lastName.isNotEmpty
    }

    // WARNING: Not sure. Maybe improve later
    func isValidDateOfBirth() -> Bool {
        return dateOfBirth != 0
    }

    func isValidPhone() -> Bool {
        return phone.count >= SignUpValidator.MinPhoneLength
    }

    func isValidEmail() -> Bool {
        guard email.isNotEmpty else { return false }
        return email.isEmail()
    }

    func isValidPassword() -> Bool {
        return password.isNotEmpty
    }

    func isValidRepeatPassword() -> Bool {
        return repeatPassword.isNotEmpty
    }

    func isBothPasswordsMatch() -> Bool {
        return password == repeatPassword
    }
}
