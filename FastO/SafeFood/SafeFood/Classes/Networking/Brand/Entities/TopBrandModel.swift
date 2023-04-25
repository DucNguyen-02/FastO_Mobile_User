//
//  TopBrandModel.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/18/22.
//

import Foundation
import SwiftyJSON

struct TopBrandModel {
    let id: Int
    let name: String
    let status: StatusBrand
    let description: String
    let phone: String
    let logo: String
    let ratings: Int
    let ratingNumber: Double

    init(json: JSON) {
        id = json["id"].intValue
        name = json["shopName"].stringValue
        description = json["description"].stringValue
        phone = json["phone"].stringValue
        logo = json["banner"].stringValue
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
    }
}
