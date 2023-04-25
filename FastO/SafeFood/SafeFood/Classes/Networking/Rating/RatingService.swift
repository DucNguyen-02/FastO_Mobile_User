import Foundation
import SwiftyJSON

// MARK: - BrandServiceProtocol

protocol RatingServiceProtocol {
    func postRating(_ params: [String: Any], completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func getRatings(id: Int, completion: @escaping ServiceRequestCompletion<[ReviewModel]>)
}

// MARK: - BrandService

final class RatingService: RatingServiceProtocol {
    static let shared = RatingService()
    
    private var networkAdapter: NetworkAdapter = NetworkAdapterImpl()
    
    func postRating(_ params: [String: Any], completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: RatingRouter.postRating(params)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRatings(id: Int, completion: @escaping ServiceRequestCompletion<[ReviewModel]>) {
        networkAdapter.request(target: RatingRouter.getRating(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJSON = JSON(data)["content"]
                    let rating = dataJSON.arrayValue.map { ReviewModel(json: $0) }
                    completion(.success(rating))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }

}
