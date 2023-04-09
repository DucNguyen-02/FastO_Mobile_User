import Foundation
import SwiftyJSON

// MARK: - LostAndFoundService

protocol NotificationServiceProtocol {
    func getListNotification(page: Int, completion: @escaping ServiceRequestCompletion<[NotificationModel]>)
    func putSeenNotification(seen: [Int], completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
}

final class NotificationService: NotificationServiceProtocol {

    static let shared = NotificationService()

    private let networkAdapter: NetworkAdapter = NetworkAdapterImpl()

    func getListNotification(page: Int, completion: @escaping ServiceRequestCompletion<[NotificationModel]>) {
        networkAdapter.request(target: NotificationRouter.getListNotification(page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]["result"]
                    let notification = dataJson.arrayValue.map { NotificationModel(json: $0)}
                    completion(.success(notification))
                } catch {
                    completion(.failure(.mappingError()))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func putSeenNotification(seen: [Int], completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: NotificationRouter.putSeenNotification(seen: seen)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
