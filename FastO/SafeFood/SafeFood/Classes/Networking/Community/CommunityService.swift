import Foundation
import SwiftyJSON

// MARK: - CommunityServiceProtocol

protocol CommunityServiceProtocol {
    func getTopCommunity(completion: @escaping ServiceRequestCompletion<[HomeCommunityModel]>)
    func getListCommunity(id: Int?, completion: @escaping ServiceRequestCompletion<[CommunityModel]>)
    func getDetailCommunity(id: Int, completion: @escaping ServiceRequestCompletion<DetailCommunityModel>)
    func postCreateCommunity(_ review: [String: Any], completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func putUpdateCommunity(id: Int, _ review: [String: Any], completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func postCreateComment(id: Int, _ content: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func postLikeReview(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func postLikeComment(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func deleteReview(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func deleteComment(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
}

// MARK: - CommunityService

final class CommunityService: CommunityServiceProtocol {
    
    // MARK: - Private Variable
    
    private var networkAdapter: NetworkAdapter = NetworkAdapterImpl()
    
    static let shared = CommunityService()
    
    func getListCommunity(id: Int?, completion: @escaping ServiceRequestCompletion<[CommunityModel]>) {
        networkAdapter.request(target: CommunityRouter.getListCommunity(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJSON = JSON(data)["data"]["result"]
                    let community = dataJSON.arrayValue.map { CommunityModel(json: $0) }
                    completion(.success(community))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
    func getTopCommunity(completion: @escaping ServiceRequestCompletion<[HomeCommunityModel]>) {
        networkAdapter.request(target: CommunityRouter.getTopCommunity) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJSON = JSON(data)["data"]["result"]
                    let community = dataJSON.arrayValue.map { HomeCommunityModel(json: $0) }
                    completion(.success(community))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
    func getDetailCommunity(id: Int, completion: @escaping ServiceRequestCompletion<DetailCommunityModel>) {
        networkAdapter.request(target: CommunityRouter.getDetailCommunity(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJSON = JSON(data)["data"]
                    let post = DetailCommunityModel(json: dataJSON)
                    completion(.success(post))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postCreateCommunity(_ review: [String: Any], completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: CommunityRouter.postCreateCommunity(review)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case let.failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
    func putUpdateCommunity(id: Int, _ review: [String: Any], completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: CommunityRouter.putUpdateCommunity(id: id, review)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case let.failure(error):
                completion(.failure(error))
            }
        }
    }
    func postCreateComment(id: Int, _ content: String, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: CommunityRouter.postCreateComment(id: id, content: content)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case let.failure(error):
                completion(.failure(error))
            }
        }
    }
    func postLikeReview(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: CommunityRouter.postLikeReview(id: id)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case let.failure(error):
                completion(.failure(error))
            }
        }
    }
    func postLikeComment(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: CommunityRouter.postLikeComment(commentId: id)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case let.failure(error):
                completion(.failure(error))
            }
        }
    }
    func deleteReview(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: CommunityRouter.deleteReview(id: id)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case let.failure(error):
                completion(.failure(error))
            }
        }
    }
    func deleteComment(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: CommunityRouter.deleteComment(id: id)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case let.failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
