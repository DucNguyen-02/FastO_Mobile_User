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
    let status: StatusBrand
    let description: String
    let phone: String
    let logo: String
    let ratings: Int
    let ratingNumber: Double
    let x: Double
    let y: Double

    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        description = json["description"].stringValue
        phone = json["phone"].stringValue
        logo = json["logo"].stringValue
        ratingNumber = json["startRatings"].doubleValue
        ratings = json["ratings"].intValue

        let status = json["status"].stringValue

        if status == StatusBrand.active.rawValue {
            self.status = .active
        } else if status == StatusBrand.inactive.rawValue {
            self.status = .inactive
        } else if status == StatusBrand.deleted.rawValue {
            self.status = .deleted
        } else {
            self.status = .blocked
        }
        x = json["x"].doubleValue
        y = json["y"].doubleValue
    }
}
