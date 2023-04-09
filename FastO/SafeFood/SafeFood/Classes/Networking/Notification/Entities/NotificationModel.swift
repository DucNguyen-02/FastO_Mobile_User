import Foundation
import SwiftyJSON

struct NotificationModel {
    let notificationId: Int
    let title: String
    let content: String
    let seenFlag: Bool
    let createdAt: String
    let typeId: Int
    let type: String
    let typeName: String

    init(json: JSON) {
        notificationId = json["notificationId"].intValue
        title = json["title"].stringValue
        content = json["content"].stringValue
        seenFlag = json["seenFlag"].boolValue
        createdAt = json["createdAt"].stringValue
        typeId = json["typeId"].intValue
        type = json["type"].stringValue
        typeName = json["typeName"].stringValue
    }
}
