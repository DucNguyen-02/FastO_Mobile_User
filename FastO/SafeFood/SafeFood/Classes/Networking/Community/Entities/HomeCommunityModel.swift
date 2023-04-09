import Foundation
import SwiftyJSON

struct HomeCommunityModel {
    let reviewId: Int
    let shopId: Int
    let title: String
    let content: String
    
    init(json: JSON) {
        reviewId = json["reviewId"].intValue
        shopId = json["shopId"].intValue
        title = json["title"].stringValue
        content = json["content"].stringValue
    }
}
