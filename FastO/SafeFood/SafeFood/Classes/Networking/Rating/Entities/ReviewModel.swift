//
//  ReviewModel.swift
//  SafeFood
//
//  Created by Zipris on 28/11/2022.
//

import Foundation
import SwiftyJSON

struct ReviewModel {
    let content: String
    let ratings: Int
    let userFirstName: String
    let userId: Int
    let userImage: String
    let userLastName: String
    
    init(json: JSON) {
        content = json["content"].stringValue
        ratings = json["ratings"].intValue
        userFirstName = json["userFirstName"].stringValue
        userId = json["userId"].intValue
        userImage = json["userImage"].stringValue
        userLastName = json["userLastName"].stringValue
    }
}

