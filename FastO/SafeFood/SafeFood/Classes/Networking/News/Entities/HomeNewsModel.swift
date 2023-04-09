import Foundation
import SwiftyJSON

struct HomeNewsModel {
    let id: Int
    let title: String
    let address: String
    let content: String
    let image: String
    let subTitle: String
    
    init(json: JSON) {
        id = json["newsId"].intValue
        title = json["title"].stringValue
        address = json["address"].stringValue
        content = json["content"].stringValue
        image = json["newsImage"].stringValue
        subTitle = json["subTitle"].stringValue
    }
}
