//
//  VoucherService.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/15/22.
//

import Foundation
import SwiftyJSON

// MARK: - VoucherServiceProtocol

protocol VoucherServiceProtocol {
    func getAllVoucher(type: UserType, completion: @escaping ServiceRequestCompletion<[VoucherModel]>)
    func getTopVoucherAdmin(completion: @escaping ServiceRequestCompletion<[VoucherModel]>)
    func getTopVoucherShop(completion: @escaping ServiceRequestCompletion<[VoucherModel]>)
    func getDetailVoucher(id: Int, completion: @escaping ServiceRequestCompletion<VoucherModel>)
    func getListVoucherShop(id: Int, completion: @escaping ServiceRequestCompletion<[VoucherModel]>)
    func postVoucherApply(_ params: [String: Any], completion: @escaping ServiceRequestCompletion<[VoucherModel]>)

}

// MARK: - VoucherService

final class VoucherService: VoucherServiceProtocol {
    static let shared = VoucherService()

    private init() {}

    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private var networkAdapter: NetworkAdapter = NetworkAdapterImpl()

    func getAllVoucher(type: UserType, completion: @escaping ServiceRequestCompletion<[VoucherModel]>) {
        networkAdapter.request(target: VoucherRouter.getAllVoucher(type: type)) { result in
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

    func getListVoucherShop(id: Int, completion: @escaping ServiceRequestCompletion<[VoucherModel]>) {
        networkAdapter.request(target: VoucherRouter.getListVoucherShop(id: id)) { result in
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

    func getDetailVoucher(id: Int, completion: @escaping ServiceRequestCompletion<VoucherModel>) {
        networkAdapter.request(target: VoucherRouter.getDetailVoucher(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let voucher =  VoucherModel(json: dataJson)
                    completion(.success(voucher))
                } catch {
                    completion(.failure(.mappingError()))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getTopVoucherAdmin(completion: @escaping ServiceRequestCompletion<[VoucherModel]>) {
        networkAdapter.request(target: VoucherRouter.getTopVoucherAdmin) { result in
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

    func getTopVoucherShop(completion: @escaping ServiceRequestCompletion<[VoucherModel]>) {
        networkAdapter.request(target: VoucherRouter.getTopVoucherShop) { result in
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
    
    func postVoucherApply(_ params: [String: Any], completion: @escaping ServiceRequestCompletion<[VoucherModel]>) {
        networkAdapter.request(target: VoucherRouter.postVoucherApply(params)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
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
}
