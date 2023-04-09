import Moya

enum CommunityRouter {
    case getTopCommunity
    case getListCommunity(id: Int?)
    case getDetailCommunity(id: Int)
    case postCreateCommunity(_ review: [String: Any])
    case postCreateComment(id: Int, content: String)
    case putUpdateCommunity(id: Int, _ review: [String: Any])
    case postLikeReview(id: Int)
    case postLikeComment(commentId: Int)
    case deleteReview(id: Int)
    case deleteComment(id: Int)
}

extension CommunityRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }
    
    var path: String {
        switch self {
        case .getTopCommunity:
            return "user/community/review/top"
        case .getListCommunity:
            return "user/community/reviews"
        case let .getDetailCommunity(id):
            return  "user/community/review/\(id)"
        case .postCreateCommunity:
            return  "user/community/reviews"
        case let .postCreateComment(id, _):
            return "user/community/review/\(id)/replies"
        case let .putUpdateCommunity(id, _):
            return  "user/community/review/\(id)"
        case let .postLikeReview(id):
            return "user/community/review/\(id)/favorite"
        case let .postLikeComment(commentId):
            return "user/community/review/reply/\(commentId)/favorite"
        case let .deleteReview(id):
            return "user/community/review/\(id)"
        case let .deleteComment(commentId):
            return "/user/community/review/reply/\(commentId)"
        }
    }
    
    var method: Method {
        switch self {
        case .getTopCommunity, .getListCommunity, .getDetailCommunity:
            return .get
        case .postCreateCommunity, .postCreateComment, .postLikeReview, .postLikeComment:
            return .post
        case .putUpdateCommunity:
            return .put
        case .deleteReview, .deleteComment:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case let .getListCommunity(id):
            var params: [String: Any] = [
                "limit": 999,
                "filter": "MOST_LIKED"
            ]
            
            if id != nil {
                params["shopId"] = id
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case let .postCreateCommunity(review) ,let .putUpdateCommunity(_, review):
            return .requestParameters(parameters: review, encoding: JSONEncoding.default)
            
        case let .postCreateComment(_, content):
            let params: [String: Any] = ["content": content]
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
