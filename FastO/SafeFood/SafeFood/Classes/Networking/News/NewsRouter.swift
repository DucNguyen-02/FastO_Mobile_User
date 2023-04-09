import Moya

enum NewsRouter {
    case getHomeNews
    case getDetailNews(id: Int)
}

extension NewsRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }
    
    var path: String {
        switch self {
        case .getHomeNews:
            return "user/news"
        case let .getDetailNews(id):
            return "user/news/\(id)"

        }
    }
    
    var method: Method {
        switch self {
        case .getHomeNews, .getDetailNews:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getHomeNews:
            let params: [String: Any] = [
                "limit": 999
            ]
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
