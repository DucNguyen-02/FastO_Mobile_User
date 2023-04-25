import Moya

enum SearchRouter {
    case searchVoucher(_ keyword: String)
    case searchBrand(_ keyword: String)
}

extension SearchRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }

    var path: String {
        switch self {
        case .searchVoucher:
            return "user/vouchers"
        case .searchBrand:
            return "user/management/shop/shops"
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
        case let .searchVoucher(keyword):
            let params: [String: Any] = ["limit": 999, "query": keyword]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case let .searchBrand(keyword):
            let params: [String: Any] = ["limit": 999, "query": keyword]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        switch self {
        default:
            return APIHelper.defaultHelpers
        }
    }
}
