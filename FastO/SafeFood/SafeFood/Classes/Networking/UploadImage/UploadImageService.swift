import Foundation
import SwiftyJSON

// MARK: - UploadImageServiceProtocol

protocol UploadImageServiceProtocol {
    func uploadImage(images: [UIImage], type: String, completion: @escaping ServiceRequestCompletion<[String]>)
}

// MARK: - UploadImageService

final class UploadImageService: UploadImageServiceProtocol {
    
    static let shared = UploadImageService()
    
    private let networkAdapter: NetworkAdapter = NetworkAdapterImpl()
    
    func uploadImage(images: [UIImage], type: String, completion: @escaping ServiceRequestCompletion<[String]>) {
        networkAdapter.request(target: UploadImageRouter.uploadImage(images: images, type: type)) { result in
            switch result {
                
            case let .success(response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let images = dataJson.arrayValue.map { $0.stringValue }
                    completion(.success(images))
                    
                } catch {
                    completion(.failure(.mappingError()))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
