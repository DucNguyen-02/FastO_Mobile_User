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
}

extension BillRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }

    var path: String {
        switch self {
        case .postBill:
            return "user/bills/create"
        case .getListBill:
            return "user/bills"
        case let .getDetailBill(id):
            return "user/bills/\(id)"
        }
    }

    var method: Method {
        switch self {
        case .postBill:
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

        case let .postBill(params):
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
