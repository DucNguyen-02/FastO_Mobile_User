import Foundation
import SwiftyJSON

// MARK: - AuthenServiceProtocol

protocol AuthenServiceProtocol {
    func loginByEmail(_ email: String, password: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func signUpEmail(_ params: [String: Any], completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func loginByGoogle(_ accessToken: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func loginByFaceBook(_ accessToken: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func forgotPassword(_ email: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func digitCodeActive(_ code: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func resendDigitCodeActive(_ email: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func digitCodeForgotPassword(_ code: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func resetPassword(_ authToken: String, password: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func logout(completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
}

// MARK: - AuthenService

final class AuthenService: AuthenServiceProtocol {
    static let shared = AuthenService()
    
    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private var networkAdapter: NetworkAdapter = NetworkAdapterImpl()
    
    func loginByEmail(
        _ email: String,
        password: String,
        completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>
    ) {
        networkAdapter.request(target: AuthenRouter.login(email: email, password: password)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let status = dataJson["status"].stringValue
                    let refreshToken = dataJson["refreshToken"].stringValue
                    let accessToken = dataJson["accessToken"].stringValue
                    let userId = dataJson["userId"].intValue
                    self.defaultsStorage.status = status
                    self.defaultsStorage.refreshToken = refreshToken
                    self.defaultsStorage.accessToken = accessToken
                    self.defaultsStorage.id = userId
                    completion(.success(ServiceRequestSuccessModel()))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signUpEmail(
        _ params: [String: Any],
        completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>
    ) {
        networkAdapter.request(target: AuthenRouter.signUp(params: params)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loginByGoogle(_ accessToken: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: AuthenRouter.loginByGoogle(accessToken: accessToken, tokenType: APIConstant.tokenType)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let refreshToken = dataJson["refreshToken"].stringValue
                    let accessToken = dataJson["accessToken"].stringValue
                    self.defaultsStorage.refreshToken = refreshToken
                    self.defaultsStorage.accessToken = accessToken
                    completion(.success(ServiceRequestSuccessModel()))
                } catch {
                    completion(.failure(.mappingError()))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loginByFaceBook(_ accessToken: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: AuthenRouter.loginByFaceBook(accessToken: accessToken, tokenType: APIConstant.tokenType)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let refreshToken = dataJson["refreshToken"].stringValue
                    let accessToken = dataJson["accessToken"].stringValue
                    self.defaultsStorage.refreshToken = refreshToken
                    self.defaultsStorage.accessToken = accessToken
                    completion(.success(ServiceRequestSuccessModel()))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func forgotPassword(
        _ email: String,
        completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>
    ) {
        networkAdapter.request(target: AuthenRouter.forgotPassword(email: email)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func digitCodeActive(
        _ code: String,
        completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>
    ) {
        networkAdapter.request(target: AuthenRouter.digitCodeActive(code: code)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let refreshToken = dataJson["refreshToken"].stringValue
                    let accessToken = dataJson["accessToken"].stringValue
                    self.defaultsStorage.refreshToken = refreshToken
                    self.defaultsStorage.accessToken = accessToken
                    completion(.success(ServiceRequestSuccessModel()))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func resendDigitCodeActive(
        _ email: String,
        completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>
    ) {
        networkAdapter.request(target: AuthenRouter.resendDigitCodeActive(email: email)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func digitCodeForgotPassword(
        _ code: String,
        completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>
    ) {
        networkAdapter.request(target: AuthenRouter.digitCodeForgotPassword(code: code)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let accessToken = dataJson.stringValue
                    self.defaultsStorage.accessToken = accessToken
                    completion(.success(ServiceRequestSuccessModel()))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func resetPassword(
        _ authToken: String,
        password: String,
        completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>
    ) {
        networkAdapter.request(target: AuthenRouter.resetPassword(authToken: authToken, password: password)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout(completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: AuthenRouter.logout) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
