import Moya

enum AuthenRouter {
    case login(email: String, password: String)
    case signUp(params: [String: Any])
    case loginByGoogle(accessToken: String, tokenType: String)
    case loginByFaceBook(accessToken: String, tokenType: String)
    case forgotPassword(email: String)
    case digitCodeActive(code: String)
    case resendDigitCodeActive(email: String)
    case digitCodeForgotPassword(code: String)
    case resetPassword(authToken: String, password: String)
    case logout
}

extension AuthenRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }
    
    var path: String {
        switch self {
        case .login:
            return "user/authentication/login"
        case .signUp:
            return "user/authentication/sign-up"
        case .loginByGoogle:
            return "user/authentication/login-app/google"
        case .loginByFaceBook:
            return "user/authentication/login-app/facebook"
        case .digitCodeActive:
            return "user/authentication/sign-up/active"
        case .resendDigitCodeActive:
            return "user/authentication/sign-up/re-send-code"
        case .forgotPassword:
            return "user/authentication/forgot-password"
        case .digitCodeForgotPassword:
            return "user/authentication/forgot-password/verify-code"
        case .resetPassword:
            return "user/authentication/forgot-password/reset"
        case .logout:
            return "user/authentication/logout"
        }
    }
    
    var method: Method {
        switch self {
        case .login, .signUp, .loginByGoogle, .loginByFaceBook, .forgotPassword, .digitCodeActive, .resendDigitCodeActive, .digitCodeForgotPassword, .resetPassword:
            return .post
            
        case .logout:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case let .login(email, password):
            let params: [String: Any] = [
                "email": email,
                "password": password
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case let .signUp(params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case let .loginByGoogle(accessToken, tokenType):
            let params: [String: Any] = [
                "accessToken": accessToken,
                "tokenType": tokenType
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case let .loginByFaceBook(accessToken, tokenType):
            let params: [String: Any] = [
                "accessToken": accessToken,
                "tokenType": tokenType
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case let .forgotPassword(email):
            let params: [String: Any] = [
                "email": email
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case let .digitCodeActive(code):
            let params: [String: Any] = [
                "code": code
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case let .resendDigitCodeActive(email):
            let params: [String: Any] = [
                "email": email
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case let .digitCodeForgotPassword(code):
            let params: [String: Any] = [
                "code": code
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case let .resetPassword(authToken, password):
            let params: [String: Any] = [
                "authToken": authToken,
                "newPassword": password
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .logout:
            return APIHelper.defaultHelpers

        default:
            return nil
        }
    }
}
