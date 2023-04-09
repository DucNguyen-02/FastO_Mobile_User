//
//  BillService.swift
//  SafeFood
//
//  Created by ADMIN on 20/11/2022.
//

import Foundation
import SwiftyJSON

// MARK: - BillServiceProtocol

protocol BillServiceProtocol {
    func getListBill(status: String , query: String?, completion: @escaping ServiceRequestCompletion<[ListBillModel]>)
    func postBill(_ params: [String: Any], completion: @escaping ServiceRequestCompletion<Int>)
    func getDetailBill(id: Int, completion: @escaping ServiceRequestCompletion<DetailBillModel>)

}

// MARK: - BillService

final class BillService: BillServiceProtocol {
    static let shared = BillService()

    private init() {}

    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private var networkAdapter: NetworkAdapter = NetworkAdapterImpl()
    
    func getListBill( status: String, query: String?, completion: @escaping ServiceRequestCompletion<[ListBillModel]>) {
        networkAdapter.request(target: BillRouter.getListBill(status: status, query: query)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let bill = dataJson.arrayValue.map { ListBillModel(json: $0) }
                    completion(.success(bill))
                } catch {
                    completion(.failure(.mappingError()))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postBill(_ params: [String: Any], completion: @escaping ServiceRequestCompletion<Int>) {
        networkAdapter.request(target: BillRouter.postBill(params)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]["billId"]
                    let billId = dataJson.intValue
                    completion(.success(billId))
                } catch {
                    completion(.failure(.mappingError()))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getDetailBill(id: Int, completion: @escaping ServiceRequestCompletion<DetailBillModel>) {
        networkAdapter.request(target: BillRouter.getDetailBill(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let bill = DetailBillModel(json: dataJson)
                    completion(.success(bill))
                } catch {
                    completion(.failure(.mappingError()))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
