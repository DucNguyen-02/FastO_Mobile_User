private let defaultLanguage = "en"

import Foundation

protocol LocalizationService: AnyObject {
    func availableLanguages() -> [Language]
    func setCurrentLanguage(_ language: Language)
    func obtainCurrentLanguageID() -> LanguageIdentifier
}

final class LocalizationServiceImpl: LocalizationService {
    
    var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    var notificationCenterService: NotificationCenterService = NotificationCenter.default
}

// MARK: - LocalizationService

extension LocalizationServiceImpl {
    func availableLanguages() -> [Language] {
        let systemLanguageIdentifiers = systemAvailableLanguages().compactMap { LanguageIdentifier(rawValue: $0) }
        return systemLanguageIdentifiers.map { Language(systemIdentifier: $0,
                                                        displayName: displayNameForLanguageIdentifier($0),
                                                        isCurrent: $0.rawValue == currentLanguage() ? true : false) }
    }
    
    func setCurrentLanguage(_ language: Language) {
        let selectedLanguage = systemAvailableLanguages().contains(language.systemIdentifier.rawValue) ? language.systemIdentifier :
        LanguageIdentifier(rawValue: getDefaultLanguage())
        if selectedLanguage != LanguageIdentifier(rawValue: currentLanguage()) {
            defaultsStorage.currentLanguage = selectedLanguage?.rawValue
            notificationCenterService.post(name: LocalizationNotification.didChange, object: nil)
        }
    }
    
    func obtainCurrentLanguageID() -> LanguageIdentifier {
        return LanguageIdentifier(rawValue: currentLanguage()) ?? .english
    }
}

// MARK: - Private

private extension LocalizationServiceImpl {
    
    func systemAvailableLanguages() -> [String] {
        return [LanguageIdentifier.english.rawValue,
                LanguageIdentifier.vietnamese.rawValue]
    }
    
    func currentLanguage() -> String {
        guard let currentLanguage = defaultsStorage.currentLanguage else { return getDefaultLanguage() }
        return currentLanguage
    }
    
    func displayNameForLanguageIdentifier(_ identifier: LanguageIdentifier) -> String {
        switch identifier {
        case .english: return R.string.localizable.language_english.localized()
        case .vietnamese: return R.string.localizable.language_vietnamese.localized()
        }
    }
    
    func getDefaultLanguage() -> String {
        var primaryLanguage: String!
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else { return defaultLanguage }
        let availableLanguages = systemAvailableLanguages()
        
        if availableLanguages.contains(preferredLanguage) {
            primaryLanguage = preferredLanguage
        } else {
            primaryLanguage = defaultLanguage
        }
        defaultsStorage.currentLanguage = primaryLanguage
        return primaryLanguage
    }
}
