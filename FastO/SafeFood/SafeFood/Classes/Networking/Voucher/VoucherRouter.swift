//
//  VoucherRouter.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/15/22.
//

import Moya

enum VoucherRouter {
    case getAllVoucher(type: UserType)
    case getDetailVoucher(id: Int)
    case getListVoucherShop(id: Int)
    case getTopVoucherAdmin
    case getTopVoucherShop
    case postVoucherApply(_ params: [String: Any])
}

extension VoucherRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }

    var path: String {
        switch self {
        case .getAllVoucher:
            return "user/vouchers"
        case let .getDetailVoucher(id):
            return "user/vouchers/\(id)"
        case let .getListVoucherShop(id):
            return "user/vouchers/shop/\(id)"
        case .getTopVoucherAdmin:
            return "user/vouchers/voucher-admin"
        case .getTopVoucherShop:
            return "user/vouchers/voucher-shop"
        case .postVoucherApply:
            return "user/vouchers/bill"
        }
    }

    var method: Method {
        switch self {
        case .postVoucherApply:
            return .post
            
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .getAllVoucher(type):
            let params: [String: Any] = [
                "limit": 999,
                "userType": type.rawValue
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        case .getListVoucherShop:
            let params: [String: Any] = [
                "limit": 999
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        case let .postVoucherApply(params):
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
