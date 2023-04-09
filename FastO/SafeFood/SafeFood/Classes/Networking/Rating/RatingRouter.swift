import Moya

enum RatingRouter {
    case postRating(_ params: [String: Any])
    case getRating(id: Int)
}

extension RatingRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }
    
    var path: String {
        switch self {
        case .postRating:
            return "shops/ratings"
        case let .getRating(id):
            return "shops/ratings/\(id)"
        }
    }
    
    var method: Method {
        switch self {
        case .postRating:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .postRating(params):
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
