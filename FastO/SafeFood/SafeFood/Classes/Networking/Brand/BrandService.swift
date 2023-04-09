//
//  BrandService.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/15/22.
//


import Foundation
import SwiftyJSON

// MARK: - BrandServiceProtocol

protocol BrandServiceProtocol {
    func getListBrandFavourite(completion: @escaping ServiceRequestCompletion<[BrandFavouriteModel]>)
    func putAddBrandFavourite(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func putDeleteBrandFavourite(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func getAllShop(completion: @escaping ServiceRequestCompletion<[BrandModel]>)
    func getDetailShop(id: Int,completion: @escaping ServiceRequestCompletion<DetailBrandModel>)
    func postRecentBrand(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>)
    func getRecentBrand(completion: @escaping ServiceRequestCompletion<[BrandModel]>)
    func getListNearBrand(id: Int, completion: @escaping ServiceRequestCompletion<[NearBrandModel]>)
    func getTopBrands(completion: @escaping ServiceRequestCompletion<[TopBrandModel]>)
}

// MARK: - BrandService

final class BrandService: BrandServiceProtocol {
    static let shared = BrandService()

    private init() {}

    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private var networkAdapter: NetworkAdapter = NetworkAdapterImpl()

    func getListBrandFavourite(completion: @escaping ServiceRequestCompletion<[BrandFavouriteModel]>) {
        networkAdapter.request(target: BrandRouter.getListBrandFavourite) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let brands = dataJson.arrayValue.map { BrandFavouriteModel(json: $0) }
                    completion(.success(brands))
                } catch {
                    completion(.failure(.mappingError()))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    func getAllShop(completion: @escaping ServiceRequestCompletion<[BrandModel]>) {
        networkAdapter.request(target: BrandRouter.getAllShop) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]["result"]
                    let brand = dataJson.arrayValue.map { BrandModel(json: $0) }
                    completion(.success(brand))
                } catch {
                    completion(.failure(.mappingError()))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getDetailShop(id: Int,completion: @escaping ServiceRequestCompletion<DetailBrandModel>) {
        networkAdapter.request(target: BrandRouter.getDetailShop(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let brand = DetailBrandModel(json: dataJson)
                    completion(.success(brand))
                } catch {
                    completion(.failure(.mappingError()))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func postRecentBrand(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: BrandRouter.postRecentBrand(id: id)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getRecentBrand(completion: @escaping ServiceRequestCompletion<[BrandModel]>) {
        networkAdapter.request(target: BrandRouter.getRecentBrand) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let brand = dataJson.arrayValue.map { BrandModel(json: $0) }
                    completion(.success(brand))
                } catch {
                    completion(.failure(.mappingError()))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getListNearBrand(id: Int, completion: @escaping ServiceRequestCompletion<[NearBrandModel]>) {
        networkAdapter.request(target: BrandRouter.getListNearBrand(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]["result"]
                    let brand = dataJson.arrayValue.map { NearBrandModel(json: $0) }
                    completion(.success(brand))
                } catch {
                    completion(.failure(.mappingError()))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getTopBrands(completion: @escaping ServiceRequestCompletion<[TopBrandModel]>) {
        networkAdapter.request(target: BrandRouter.getTopBrands) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)["data"]
                    let brand = dataJson.arrayValue.map { TopBrandModel(json: $0) }
                    completion(.success(brand))
                } catch {
                    completion(.failure(.mappingError()))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func putAddBrandFavourite(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: BrandRouter.putAddBrandFavourite(id: id)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func putDeleteBrandFavourite(id: Int, completion: @escaping ServiceRequestCompletion<ServiceRequestSuccessModel>) {
        networkAdapter.request(target: BrandRouter.putDeleteBrandFavourite(id: id)) { result in
            switch result {
            case .success:
                completion(.success(ServiceRequestSuccessModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
