//
//  UserCommunityModel.swift
//  SafeFood
//
//  Created by Zipris on 23/11/2022.
//

import Foundation
import SwiftyJSON
struct UserReviewModel {
    let id: Int
    let name: String
    let image: String
    
    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        image = json["imageUrl"].stringValue
        
    }
}
