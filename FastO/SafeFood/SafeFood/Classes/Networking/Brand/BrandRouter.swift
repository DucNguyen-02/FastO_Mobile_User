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
            return "user/fauvourite/shops"
        case let .putAddBrandFavourite(id):
            return "user/fauvourite/shops/add/\(id)"
        case let .putDeleteBrandFavourite(id):
            return "user/fauvourite/shops/delete/\(id)"
        case .getAllShop:
            return "users/shops/shops"
        case let .getDetailShop(id):
            return "users/shops/detail/\(id)"
        case .postRecentBrand:
            return "users/shops/create/recent-shop"
        case .getRecentBrand:
            return "users/shops/recent-shops"
        case .getListNearBrand:
            return "users/shops/distance-shop"
        case .getTopBrands:
            return "users/shops/top"
        }
    }

    var method: Method {
        switch self {
        case .postRecentBrand:
            return .post
        
        case .putAddBrandFavourite, .putDeleteBrandFavourite:
            return .put
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
            return APIHelper.defaultHelpers
        }
    }
}
