//
//  ProductService.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/15/22.
//

import Foundation
import SwiftyJSON

// MARK: - ProductServiceProtocol

protocol ProductServiceProtocol {
    func getDetailProduct(id: Int, completion: @escaping ServiceRequestCompletion<ProductModel>)
    func getProductMenu(id: Int, completion: @escaping ServiceRequestCompletion<[ProductModel]>)
}

// MARK: - BrandService

final class ProductService: ProductServiceProtocol {
    static let shared = ProductService()

    private init() {}

    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private var networkAdapter: NetworkAdapter = NetworkAdapterImpl()

    func getDetailProduct(id: Int, completion: @escaping ServiceRequestCompletion<ProductModel>) {
        networkAdapter.request(target: ProductRouter.getDetailProduct(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)
                    let product = ProductModel(json: dataJson)
                    completion(.success(product))
                } catch {
                    completion(.failure(.mappingError()))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getProductMenu(id: Int, completion: @escaping ServiceRequestCompletion<[ProductModel]>) {
        networkAdapter.request(target: ProductRouter.getProductMenu(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["content"]
                    let product = dataJson.arrayValue.map { ProductModel(json: $0) }
                    completion(.success(product))
                } catch {
                    completion(.failure(.mappingError()))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
