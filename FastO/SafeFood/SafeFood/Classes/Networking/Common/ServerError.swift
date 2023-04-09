import Foundation
import Moya

struct ErrorStatusCode: Equatable {
    static let success = 200
    static let badRequest = 400
    static let unauthorized = 401
    static let pageNotFound = 404
    static let timeout = 408
    static let serverError = 500
    static let cancelled = -999
    static let noConnection = -1009
    static let mappingError = -1
}

struct ErrorMessage: Equatable {
    static let unknownError = "Something Went Wrong"
    static let notFoundError = "Object Not Found"
    static let noInternetConnection = "No Internet Connection"
}

final class ServerError: Error {
    var message: String = ErrorMessage.unknownError
    var response: Response?
    var statusCode: Int = ErrorStatusCode.success
    var isConnectionError: Bool = false
//    var isAccessTokenChanged: Bool = false
    
    init(message: String, messageCode: String?, response: Response?, code: Int) {
        self.message = message
        self.response = response
        self.statusCode = code
    }
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

// MARK: - Decodable

extension ServerError: Decodable {
    convenience init(from decoder: Decoder) throws {
        self.init(message: ErrorMessage.unknownError, messageCode: nil, response: nil, code: ErrorStatusCode.success)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let message = try? container.decode(String.self, forKey: .message) {
            self.message = message.isNotEmpty ? message : ErrorMessage.unknownError
        }
    }
}

// MARK: - Extentions

extension ServerError {
    final class func message(_ message: String) -> ServerError {
        return ServerError(message: message,
                           messageCode: nil,
                           response: nil,
                           code: 0)
    }
    
    final class func mappingError() -> ServerError {
        return ServerError(message: ErrorMessage.unknownError,
                           messageCode: nil,
                           response: nil,
                           code: ErrorStatusCode.mappingError)
    }
    
    final class func objectNotFoundError() -> ServerError {
        return ServerError(message: ErrorMessage.notFoundError,
                           messageCode: nil,
                           response: nil,
                           code: ErrorStatusCode.pageNotFound)
    }
}

extension ServerError {
    func isHTTPError() -> Bool {
        return statusCode >= 400
    }
    
    func isMappingError() -> Bool {
        return statusCode == ErrorStatusCode.mappingError
    }
    
    func isBadRequestError() -> Bool {
        return statusCode == ErrorStatusCode.badRequest
    }
    
    var isTimeoutError: Bool {
        return statusCode == ErrorStatusCode.timeout
    }
}
