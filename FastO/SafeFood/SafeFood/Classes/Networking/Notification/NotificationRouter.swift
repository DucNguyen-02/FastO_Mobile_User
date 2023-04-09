import Moya

enum NotificationRouter {
    case getListNotification(page: Int)
    case putSeenNotification(seen: [Int])
}

extension NotificationRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }

    var path: String {
        switch self {
        case .getListNotification:
            return "user/notification"
        case .putSeenNotification:
            return "user/notification/seen-flag"
        }
    }

    var method: Method {
        switch self {
        case .putSeenNotification:
            return .put
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .getListNotification(page):
            let params: [String: Any] = [
                "page": page,
                "types": "REVIEW, REPLY"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case let .putSeenNotification(seen):
            let params: [String: Any] = [
                "notificationIds": seen
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        switch self {
        default:
            return APIHelper.defaultHelpers
        }
    }
}
