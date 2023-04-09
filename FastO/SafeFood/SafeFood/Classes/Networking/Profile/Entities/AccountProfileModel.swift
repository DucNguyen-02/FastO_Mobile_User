import Foundation
import SwiftyJSON

struct AccountProfileModel: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let gender: String
    let birthday: Date
    let userImage: String
    let birthdayDouble: Double
    
    init(json: JSON) {
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue
        gender = json["gender"].stringValue
        birthdayDouble = json["birthday"].doubleValue
        birthday = Date(timeIntervalSince1970: TimeInterval(json["birthday"].doubleValue))
        userImage = json["userImage"].stringValue
        id = json["userInformationId"].intValue
    }
}

extension AccountProfileModel {
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["firstName"] = firstName
        dict["lastName"] = lastName
        dict["gender"] = gender
        dict["birthday"] = birthdayDouble
        dict["userImage"] = userImage
        return dict
    }
}
