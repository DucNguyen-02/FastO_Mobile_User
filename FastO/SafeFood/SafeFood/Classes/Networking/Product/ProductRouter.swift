//
//  ProductRouter.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/15/22.
//


import Moya

enum ProductRouter {
    case getDetailProduct(id: Int)
    case getProductMenu(id: Int)
}

extension ProductRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }

    var path: String {
        switch self {
        case let .getDetailProduct(id):
            return "user/products/shop/detail/\(id)"
        case let .getProductMenu(id):
            return "user/products/\(id)"
        }
    }

    var method: Method {
        switch self {
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
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
