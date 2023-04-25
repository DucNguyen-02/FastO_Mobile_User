import Moya

enum UserRouter {
    case getUserProfile
    case postProfile(_ info: [String: Any])
    case changePassword(_ params: [String: Any])
    case changeAvatar(avatar: String)
}

extension UserRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }
    
    var path: String {
        switch self {
        case .getUserProfile:
            return "user/management/information"
        case .postProfile:
            return "user/management/information"
        case .changePassword:
            return "user/authenticate/change-password"
        case .changeAvatar:
            return "user/management/information/update-avatar"
        }
    }
    
    var method: Method {
        switch self {
        case .postProfile, .changePassword:
            return .post
            
        case .changeAvatar:
            return .patch
            
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .postProfile(info), let .changePassword(info):
            return .requestParameters(parameters: info, encoding: JSONEncoding.default)

        case let .changeAvatar(avatar):
            let param: [String: Any] = ["avatar": avatar]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
            
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
