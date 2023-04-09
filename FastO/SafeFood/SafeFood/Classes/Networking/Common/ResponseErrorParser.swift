import Foundation
import Moya

final class ResponseErrorParser {
    static func parseError(error: Error) -> ServerError {
        if let error = error as? MoyaError {
            if let response = error.response {
                if let errorModel = try? response.map(ServerError.self) {
                    return errorModel
                }
            }
        }
        return ServerError(message: ErrorMessage.unknownError,
                           messageCode: nil,
                           response: nil,
                           code: ErrorStatusCode.serverError)
    }
}
