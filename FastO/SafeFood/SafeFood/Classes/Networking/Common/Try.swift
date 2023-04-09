import Foundation

typealias TryEmpty = Try<()>

enum Try<T> {
    case success(T)
    case failure(ServerError)
    
    init(_ factory: () throws -> T) {
        do {
            self = .success(try factory())
        } catch {
            if let error = error as? ServerError {
                self = .failure(error)
            } else {
                self = .failure(ResponseErrorParser.parseError(error: error))
            }
        }
    }
    
    init(_ value: T) {
        self = .success(value)
    }
    
    init(_ error: ServerError) {
        self = .failure(error)
    }
    
    init(_ optional: T?, else factory: @autoclosure () -> ServerError) {
        if let t = optional {
            self = .success(t)
        } else {
            self = .failure(factory())
        }
    }
    
    func flatMap<U>(_ transform: (T) -> Try<U>) -> Try<U> {
        switch self {
        case .success(let t):
            return transform(t)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
