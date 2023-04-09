import Foundation

class APIHelper {
    
    // MARK: - Public Variable
    
    static var defaultHelpers: [String: String]? {
        let defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
        
        if let accessToken = defaultsStorage.accessToken,
           accessToken.isNotEmpty {
            return ["Authorization": "Bearer \(accessToken)"]
        }
        
        return nil
    }
}
