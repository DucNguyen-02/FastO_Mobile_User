import Moya

enum LocationRouter {
    case getListBrandLocation(_ latitude: Double, _ longitude: Double)
}

extension LocationRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }
    
    var path: String {
        switch self {
        case .getListBrandLocation:
            return "user/management/shop/distance"
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
        case let .getListBrandLocation(latitude, longitude):
            let params: [String: Any] = [
                "x": latitude,
                "y": longitude,
                "radius": 10000
            ]
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
