import Foundation

typealias FetchRequestResult<T> = Result<T, Error>
typealias ServiceRequestResult<T> = Result<T, ServerError>
typealias ServiceRequestCompletion<T> = (ServiceRequestResult<T>) -> Void

struct ServiceRequestSuccessModel: Decodable {}
