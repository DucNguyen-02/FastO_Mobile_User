import Foundation
import Moya
import Alamofire

typealias NetworkResponse = (Try<Response>) -> Void

protocol NetworkAdapter {
    func request(target: TargetType, completion: @escaping NetworkResponse)
}

final class NetworkAdapterImpl: NetworkAdapter {
    
    private lazy var provider: MoyaProvider<MultiTarget> = {
        #if DEBUG
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        return MoyaProvider(plugins: [networkLogger])
        #else
        return MoyaProvider()
        #endif
    }()
    
    func request(target: TargetType, completion: @escaping NetworkResponse) {
        provider.request(MultiTarget(target)) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    completion(.success(response))
                } catch let error {
                    let serverError = ResponseErrorParser.parseError(error: error)
                    serverError.statusCode = response.statusCode
                    serverError.response = response
                    completion(.failure(serverError))
                }
            case .failure(let error):
                switch error {
                case .underlying(let nsError as NSError, _):
                    let isExplicitlyCancelled = (nsError as? AFError)?.isExplicitlyCancelledError ?? false
                    guard nsError.code != ErrorStatusCode.cancelled && !isExplicitlyCancelled  else { return }
                    let errorMessage = nsError.code == ErrorStatusCode.noConnection ? ErrorMessage.noInternetConnection : nsError.localizedDescription
                    let serverError = ServerError(message: errorMessage, messageCode: nil, response: nil, code: nsError.code)
                    serverError.isConnectionError = true
                    completion(.failure(serverError))
                default:
                    let serverError = ServerError(message: ErrorMessage.noInternetConnection,
                                                  messageCode: nil,
                                                  response: nil,
                                                  code: error.response?.statusCode ?? 0)
                    serverError.isConnectionError = true
                    completion(.failure(serverError))
                }
            }
        }
    }
}
