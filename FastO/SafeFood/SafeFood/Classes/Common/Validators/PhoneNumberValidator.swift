import Foundation

enum PhoneNumberValidationResult: Equatable {
  case valid
  case error(PhoneNumberValidationError)
}

enum PhoneNumberValidationError {
  case empty
  case minimumLength
  case invalid
}

protocol PhoneNumberValidator {
  func validate(_ phoneNumber: String?) -> PhoneNumberValidationResult
}

final class PhoneNumberValidatorImpl: PhoneNumberValidator {
  
  // MARK: - Private
  
  private struct Constants {
    static let phoneNumberPrefixMY = "60"
    static let minPhoneNumberLength = 9
    static let maxPhoneNumberLength = 10
  }
  
  // MARK: - Public
  
  func validate(_ phoneNumber: String?) -> PhoneNumberValidationResult {
    guard let phoneNumber = phoneNumber else {
      return .error(.empty)
    }
    
    if phoneNumber.count < Constants.minPhoneNumberLength {
      return .error(.minimumLength)
    }

    let result = validateMYPhoneNumber(phoneNumber)
    
    return result ? .valid : .error(.invalid)
  }
}

private extension PhoneNumberValidatorImpl {
  func validateMYPhoneNumber(_ phoneNumber: String) -> Bool {
    let pattern = "^(\(Constants.phoneNumberPrefixMY))?1[0-9]{\(Constants.minPhoneNumberLength - 1),\(Constants.maxPhoneNumberLength - 1)}$"
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    let nsRange = NSRange(phoneNumber.startIndex..<phoneNumber.endIndex, in: phoneNumber)
    let matches = regex?.matches(in: phoneNumber, options: [], range: nsRange)
    let matchesCount = matches?.count ?? 0
    
    return matchesCount > 0
  }
}
