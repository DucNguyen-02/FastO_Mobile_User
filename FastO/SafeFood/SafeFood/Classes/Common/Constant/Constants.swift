import Foundation

struct LangConstants {
    
    struct PublicLinks {
        static let termsLink = ""
        static let faqLink = ""
    }
    
    struct LanguageShortIdentifier {
        static let english = "EN"
        static let vietnamese = "VN"
    }
    
    struct LanguageLaunchDisplay {
        static let english = "English"
        static let vietnamese = "Tiếng Việt"
    }
}

struct APIConstant {
    static let baseURL = "https://safefood.fun/api/"
    static let tokenType = "Bearer"
    static let vnpayRedirectUrl = "safefood://"
    static let vnPayBankCode = "NCB"
    static let vnPayLocale = "vn"
    static let vnPayOderType = "other"
}

struct GoogleAppAuth {
    static let kIssuer: String = "https://accounts.google.com"
    static let kClientID: String? = "334767551062-09su2ttgnie5s6p07s7gli54cps9f3km.apps.googleusercontent.com"
    static let kRedirectURI = "com.googleusercontent.apps.334767551062-09su2ttgnie5s6p07s7gli54cps9f3km:/oauth2redirect/google"
}
