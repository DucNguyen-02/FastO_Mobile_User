import Moya

enum PaymentRouter {
    case vnPayMethod(requestModel: VNPaymentRequestModel)
    case getVNPayResult(requestModel: VNPaymentResultRequestModel)
}

extension PaymentRouter: TargetType {

    var baseURL: URL { return URL(string: APIConstant.baseURL)! }

    var path: String {
        switch self {
        case .vnPayMethod:
            return "user/management/vn-pay/vnpay/payment-url"
            
        case .getVNPayResult:
            return "user/management/vn-pay/vnpay/return-url"
        }
    }

    var method: Method {
        switch self {
        case .vnPayMethod:
            return .post
        case .getVNPayResult:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .vnPayMethod(requestModel):
            return .requestJSONEncodable(requestModel)
            
        case let .getVNPayResult(requestModel):
            let params = requestModel.toDict()
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return APIHelper.defaultHelpers
        }
    }
}
