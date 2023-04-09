import Foundation
import SwiftyJSON

// MARK: - ProfileServiceProtocol

protocol UserServiceProtocol {
    func getUserProfile(completion: @escaping ServiceRequestCompletion<AccountProfileModel>)
    func postProfile(_ info: [String: Any], completion: @escaping ServiceRequestCompletion<AccountProfileModel>)
    func changePassword(_ params: [String: Any], completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func changeAvatar(avatar: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
}

// MARK: - ProfileService

final class UserService: UserServiceProtocol {
    static let shared = UserService()
    
    private init() {}
    
    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private var networkAdapter: NetworkAdapter = NetworkAdapterImpl()
    
    func getUserProfile(completion: @escaping ServiceRequestCompletion<AccountProfileModel>) {
        networkAdapter.request(target: UserRouter.getUserProfile) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let userProfile = AccountProfileModel(json: dataJson)
                    self.defaultsStorage.user = userProfile
                    completion(.success(userProfile))
                } catch {
                    completion(.failure(.mappingError()))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postProfile(_ info: [String: Any], completion: @escaping ServiceRequestCompletion<AccountProfileModel>) {
        networkAdapter.request(target: UserRouter.postProfile(info)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let userProfile = AccountProfileModel(json: dataJson)
                    completion(.success(userProfile))
                } catch {
                    completion(.failure(.mappingError()))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func changePassword( _ params: [String: Any], completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>
    ) {
        networkAdapter.request(target: UserRouter.changePassword(params)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func changeAvatar( avatar: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>
    ) {
        networkAdapter.request(target: UserRouter.changeAvatar(avatar: avatar)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
