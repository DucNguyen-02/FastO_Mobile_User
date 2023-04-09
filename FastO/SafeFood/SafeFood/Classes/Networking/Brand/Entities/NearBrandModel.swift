//
//  NearBrandModel.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/15/22.
//

import Foundation
import SwiftyJSON

struct NearBrandModel {
    let id: Int
    let logo: String
    let name: String
    let description: String
    let distance: Double
    let street: String
    let x: Double
    let y: Double
    let ratings: Int
    let ratingNumber: Double

    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        description = json["description"].stringValue
        logo = json["logo"].stringValue
        ratingNumber = json["startRatings"].doubleValue
        ratings = json["ratings"].intValue
        distance = json["distance"].doubleValue
        street = json["street"].stringValue
        x = json["x"].doubleValue
        y = json["y"].doubleValue
    }
}
