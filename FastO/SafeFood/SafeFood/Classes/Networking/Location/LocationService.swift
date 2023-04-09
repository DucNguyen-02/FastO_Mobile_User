import Foundation
import SwiftyJSON

// MARK: - LocationServiceProtocol

protocol LocationServiceProtocol {
    func getListBrandLocation(_ latitude: Double, _ longitude: Double, completion: @escaping ServiceRequestCompletion<[BrandModel]>)
}

// MARK: - LocationService

final class LocationService: LocationServiceProtocol {
    static let shared = LocationService()
    
    private let networkAdapter: NetworkAdapter = NetworkAdapterImpl()
    
    func getListBrandLocation(_ latitude: Double, _ longitude: Double, completion: @escaping ServiceRequestCompletion<[BrandModel]>) {
        networkAdapter.request(target: LocationRouter.getListBrandLocation(latitude, longitude)) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]["result"]
                    let listBrandLocation = dataJson.arrayValue.map { BrandModel(json: $0) }
                    completion(.success(listBrandLocation))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
