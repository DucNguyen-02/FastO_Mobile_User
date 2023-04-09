import Foundation

extension String {
    public func isEmail() -> Bool {
        if self.cleanUpWhitespaces().isEmpty { return false }
        let emailRegex = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    public func isValidPassword() -> Bool {
        if self.isEmpty { return false }
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,10}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    public func isValidPhoneNumber() -> Bool {
        if self.isEmpty { return false }
        let minPhoneNumberLength = 9
        let maxPhoneNumberLength = 10
        
        let pattern = "^[0-9]{\(minPhoneNumberLength),\(maxPhoneNumberLength)}$"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsRange = NSRange(self.startIndex..<self.endIndex, in: self)
        let matches = regex?.matches(in: self, options: [], range: nsRange)
        let matchesCount = matches?.count ?? 0
        
        return matchesCount > 0
    }
    
    public func isValidPhoneNumberVN() -> Bool {
        if self.isEmpty { return false }
        let pattern = "(0[3|5|7|8|9])+([0-9]{8})"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsRange = NSRange(self.startIndex..<self.endIndex, in: self)
        let matches = regex?.matches(in: self, options: [], range: nsRange)
        let matchesCount = matches?.count ?? 0
        
        return matchesCount > 0
    }
    
    public func isEqualPasswordConfirm(passwordConfirm: String) -> Bool {
        self == passwordConfirm
    }
}
