import Moya

enum UploadImageRouter {
    case uploadImage(images: [UIImage], type: String)
}

extension UploadImageRouter: TargetType {
    var baseURL: URL { return URL(string: APIConstant.baseURL)! }
    
    var path: String {
        switch self {
        case .uploadImage:
            return "users/image/upload"
        }
    }
    
    var method: Method {
        switch self {
        default:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .uploadImage(images, type):
            var multiParts: [MultipartFormData] = []
            for image in images {
                let multipart = MultipartFormData(provider: .data(image.jpegData(compressionQuality: 0.7)!), name: "files", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                multiParts.append(multipart)
            }
           
            return .uploadCompositeMultipart(multiParts, urlParameters: ["imageFolderType": type])
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return APIHelper.defaultHelpers
        }
    }
}
