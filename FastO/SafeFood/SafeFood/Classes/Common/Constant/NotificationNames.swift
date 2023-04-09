import Foundation

struct AccountNotifications {
    static let authorizationCompleted = Notification.Name(rawValue: "AccountAuthorizationCompleted")
    static let accountLoggedOut = Notification.Name(rawValue: "AccountLoggedOut")
}

struct LocalizationNotification {
    static let didChange = Notification.Name(rawValue: "LocalizationDidChange")
}

struct PaymentNotification {
    static let paymentVNPayCompleted = Notification.Name(rawValue: "PaymentVNPayCompleted")
}
