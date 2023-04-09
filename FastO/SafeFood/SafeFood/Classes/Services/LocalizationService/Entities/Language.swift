import Foundation

struct Language {
    let systemIdentifier: LanguageIdentifier
    let displayName: String
    let isCurrent: Bool
    
    func nuetralDisplayName() -> String {
        switch systemIdentifier {
        case .english: return LangConstants.LanguageLaunchDisplay.english
        case .vietnamese: return LangConstants.LanguageLaunchDisplay.vietnamese
        }
    }
}

// MARK: - Equatable

extension Language: Equatable {
    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.systemIdentifier == rhs.systemIdentifier && lhs.displayName == rhs.displayName && lhs.isCurrent == rhs.isCurrent
    }
}

enum LanguageIdentifier: String, Equatable {
    case english = "en"
    case vietnamese = "vn"

    var shortIdentifier: String {
        switch self {
        case .english: return LangConstants.LanguageShortIdentifier.english
        case .vietnamese: return LangConstants.LanguageShortIdentifier.vietnamese
        }
    }
}
