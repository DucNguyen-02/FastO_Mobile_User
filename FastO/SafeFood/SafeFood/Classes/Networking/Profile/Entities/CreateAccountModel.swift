//
//  CreateAccountModel.swift
//  SafeFood
//
//  Created by ADMIN on 21/11/2022.
//

import Foundation
import SwiftyJSON

struct CreateAccountModel {
    let firstName: String
    let lastName: String
    let gender: String
    let userImage: String
    let birthdayDouble: Double
    
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
