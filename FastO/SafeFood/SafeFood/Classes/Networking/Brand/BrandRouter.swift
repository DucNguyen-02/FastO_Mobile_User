//
//  BrandRouter.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/15/22.
//

import Moya

enum BrandRouter {
    case getListBrandFavourite
    case putAddBrandFavourite(id: Int)
    case putDeleteBrandFavourite(id: Int)
    case getAllShop
    case getDetailShop(id: Int)
    case postRecentBrand(id: Int)
    case getRecentBrand
    case getListNearBrand(id: Int)
    case getTopBrands
}

extension BrandRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }

    var path: String {
        switch self {
        case .getListBrandFavourite:
            return "user/management/shops"
        case let .putAddBrandFavourite(id):
            return "user/management/shops/\(id)"
        case let .putDeleteBrandFavourite(id):
            return "user/management/shops/\(id)"
        case .getAllShop:
            return "user/management/shop/shops"
        case let .getDetailShop(id):
            return "user/management/shop/detail/\(id)"
        case .postRecentBrand:
            return "user/management/shop/create/recent-shop"
        case .getRecentBrand:
            return "user/management/shop/recent-shops"
        case .getListNearBrand:
            return "user/management/shop/distance-shop"
        case .getTopBrands:
            return "user/management/shop/top-shops"
        }
    }

    var method: Method {
        switch self {
        case .postRecentBrand, .putAddBrandFavourite:
            return .post
        
        case .putDeleteBrandFavourite:
            return .delete
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getAllShop:
            let params: [String: Any] =
                ["status": "ACTIVED",
                "limit": 999]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        case let .postRecentBrand(id):
            let params: [String: Any] = ["shopId": id]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        case let .getListNearBrand(id):
            let params: [String: Any] =
                ["shopId": id,
                 "radius": 1000,
                "limit": 999]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        case .getTopBrands:
            let params: [String: Any] =
                ["dateFrom": 1669827600000,
                 "dateTo": 1672505999000,
                "top": 4]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        default:
            return ["Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJraW1ob2FuZy5kZXZAZ21haWwuY29tIiwiYXV0aCI6IlVTRVIiLCJleHAiOjE2ODQ5OTk2MTZ9.xQwO71akdOGEhcdUhzdVbmDQ_JhZ8lpcCQoV1CMh14EdAxWlPW1W3zqjjB6vH5oEMsxSJ4iib2EP0lT5cO5OJw"]
        }
    }
}
