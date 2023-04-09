import Foundation
import SwiftyJSON

// MARK: - SearchServiceProtocol

protocol SearchServiceProtocol {
    func searchVoucher(keyword: String, completion: @escaping ServiceRequestCompletion<[VoucherModel]>)
    func searchBrand(keyword: String, completion: @escaping ServiceRequestCompletion<[BrandModel]>)
}

// MARK: - SearchService

final class SearchService: SearchServiceProtocol {
    static let shared = SearchService()
    private var networkAdapter: NetworkAdapter = NetworkAdapterImpl()
    
    func searchVoucher(keyword: String, completion: @escaping ServiceRequestCompletion<[VoucherModel]>) {
        networkAdapter.request(target: SearchRouter.searchVoucher(keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]["result"]
                    let vouchers =  dataJson.arrayValue.map { VoucherModel(json: $0) }
                    completion(.success(vouchers))
                } catch {
                    completion(.failure(.mappingError()))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchBrand(keyword: String, completion: @escaping ServiceRequestCompletion<[BrandModel]>) {
        networkAdapter.request(target: SearchRouter.searchBrand(keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]["result"]
                    let vouchers =  dataJson.arrayValue.map { BrandModel(json: $0) }
                    completion(.success(vouchers))
                } catch {
                    completion(.failure(.mappingError()))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
