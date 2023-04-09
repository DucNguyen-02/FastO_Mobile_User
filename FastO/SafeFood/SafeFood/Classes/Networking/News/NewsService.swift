import Foundation
import SwiftyJSON

// MARK: - NewsServiceProtocol

protocol NewsServiceProtocol {
    func getHomeNews(completion: @escaping ServiceRequestCompletion<[HomeNewsModel]>)
    func getDetailNews(id: Int, completion: @escaping ServiceRequestCompletion<HomeNewsModel>)
}

// MARK: - NewsService

final class NewsService: NewsServiceProtocol {
    
    // MARK: - Private Variable
    
    private var networkAdapter: NetworkAdapter = NetworkAdapterImpl()
    
    static let shared = NewsService()
    
    func getHomeNews(completion: @escaping ServiceRequestCompletion<[HomeNewsModel]>) {
        networkAdapter.request(target: NewsRouter.getHomeNews) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJSON = JSON(data)["data"]["result"]
                    let homeNews = dataJSON.arrayValue.map { HomeNewsModel(json: $0) }
                    completion(.success(homeNews))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }

    func getDetailNews(id: Int, completion: @escaping ServiceRequestCompletion<HomeNewsModel>) {
        networkAdapter.request(target: NewsRouter.getDetailNews(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJSON = JSON(data)["data"]
                    let detailNew = HomeNewsModel(json: dataJSON)
                    completion(.success(detailNew))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case .failure(let error):
                completion(.failure(error))

            }
        }
    }
}
