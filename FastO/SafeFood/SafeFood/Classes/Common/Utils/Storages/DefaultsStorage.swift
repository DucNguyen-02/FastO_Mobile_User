import Foundation

protocol DefaultsStorage {
    var appLatestVersion: String? { get set }
    var currentLanguage: String? { get set }
    var refreshToken: String? { get set }
    var accessToken: String? { get set }
    var status: String? { get set }
    var id: Int? { get set }
    var user: AccountProfileModel? { get set }
    
    func cleanUpData()
}

final class DefaultsStorageImpl: DefaultsStorage {
    
    // MARK: - Init
    
    init(userDefaultsProvider: UserDefaultsProvider = UserDefaults.standard) {
        defaults = userDefaultsProvider
    }
    
    // MARK: - Private Variables
    
    private let defaults: UserDefaultsProvider
    
    // MARK: - Public Variables
    var user: AccountProfileModel? {
        get {
            do {
                return try defaults.getCustomObject(forKey: DefaultsStorageKeys.userProfileKey, castTo: AccountProfileModel.self)
            } catch {
                return nil
            }
        }
        set {
            try? defaults.setCustomObject(newValue, forKey: DefaultsStorageKeys.userProfileKey)
        }
    }
    
    var appLatestVersion: String? {
        get {
            return defaults.string(forKey: DefaultsStorageKeys.appLatestVersionKey)
        }
        set {
            defaults.set(newValue, forKey: DefaultsStorageKeys.appLatestVersionKey)
        }
    }
    
    var id: Int? {
        get {
            return defaults.integer(forKey: DefaultsStorageKeys.idAccountKey)
        }
        set {
            defaults.set(newValue, forKey: DefaultsStorageKeys.idAccountKey)
        }
    }
    
    var currentLanguage: String? {
        get {
            return defaults.string(forKey: DefaultsStorageKeys.currentLanguageKey)
        }
        set {
            defaults.set(newValue, forKey: DefaultsStorageKeys.currentLanguageKey)
        }
    }
    
    var refreshToken: String? {
        get {
            return defaults.string(forKey: DefaultsStorageKeys.refreshTokenKey)
        }
        set {
            defaults.set(newValue, forKey: DefaultsStorageKeys.refreshTokenKey)
        }
    }
    
    var accessToken: String? {
        get {
            return defaults.string(forKey: DefaultsStorageKeys.accessTokenKey)
        }
        set {
            defaults.set(newValue, forKey: DefaultsStorageKeys.accessTokenKey)
        }
    }

    var status: String? {
        get {
            return defaults.string(forKey: DefaultsStorageKeys.statusAccountKey)
        }
        set {
            defaults.set(newValue, forKey: DefaultsStorageKeys.statusAccountKey)
        }
    }
    
    func cleanUpData() {
        refreshToken = nil
        accessToken = nil
    }
}
