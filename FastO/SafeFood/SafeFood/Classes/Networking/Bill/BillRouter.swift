//
//  BillRouter.swift
//  SafeFood
//
//  Created by ADMIN on 20/11/2022.
//

import Moya

enum BillRouter {
    case postBill(_ params: [String: Any])
    case getListBill(status: String, query: String?)
    case getDetailBill(id: Int)
    case postCart(_ params: [String: Any])
}

extension BillRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }

    var path: String {
        switch self {
        case .postBill:
            return "user/management/bill/create"
        case .getListBill:
            return "user/management/bill"
        case let .getDetailBill(id):
            return "user/management/bill/\(id)"
        case .postCart:
            return "user/management/carts"
        }
    }

    var method: Method {
        switch self {
        case .postBill, .postCart:
            return .post
            
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .getListBill(status, query):
            var params: [String: Any] = [
                "status": status
            ]
            
            if query != nil {
                params["query"] = query
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        case let .postBill(params), let .postCart(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
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
