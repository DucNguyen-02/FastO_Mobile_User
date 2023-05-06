//
//  TopBrandModel.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/15/22.
//

import Foundation
import SwiftyJSON

enum StatusBrand: String {
    case active = "ACTIVED"
    case inactive = "INACTIVE"
    case deleted = "DELETED"
    case blocked = "BLOCKED"
}

struct BrandModel {
    let id: Int
    let name: String
//    let status: StatusBrand
    let distance: Double
    let description: String
    let street: String
    let logo: String
    let banner: String
    let ratings: Int
    let ratingNumber: Double
    let x: Double
    let y: Double

    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        description = json["description"].stringValue
        street = json["streetAddress"].stringValue
        logo = json["logo"].stringValue
        banner = json["banner"].stringValue
        ratingNumber = json["startRatings"].doubleValue
        ratings = json["rating"].intValue
        distance = json["distance"].doubleValue
//        let status = json["status"].stringValue

//        if status == StatusBrand.active.rawValue {
//            self.status = .active
//        } else if status == StatusBrand.inactive.rawValue {
//            self.status = .inactive
//        } else if status == StatusBrand.deleted.rawValue {
//            self.status = .deleted
//        } else {
//            self.status = .blocked
//        }
        x = json["x"].doubleValue
        y = json["y"].doubleValue
    }
}
