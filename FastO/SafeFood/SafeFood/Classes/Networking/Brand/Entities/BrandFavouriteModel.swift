//
//  BrandFavouriteModel.swift
//  SafeFood
//
//  Created by Zipris on 28/11/2022.
//

import Foundation
import SwiftyJSON

struct BrandFavouriteModel {
    let shopId: Int
    let name: String
    let banner: String
    let description: String
    let schedule: String
    let phone: String
    
    init(json: JSON) {
        shopId = json["id"].intValue
        name = json["name"].stringValue
        banner = json["banner"].stringValue
        description = json["description"].stringValue
        schedule = json["schedule"].stringValue
        phone = json["phone"].stringValue
    }
}
