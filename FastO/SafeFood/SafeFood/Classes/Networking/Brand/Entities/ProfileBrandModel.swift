//
//  ProfileBrandModel.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/16/22.
//

import Foundation
import SwiftyJSON

struct ProfileBrandModel {
    let id: Int
    let name: String
    let logo: String
    let description: String
    let phone: String
    let ratings: Int
    let ratingNumber: Double
    var images: [String] = []
    let city: String
    let disctrict: String
    let town: String
    let street: String
    let isFavourite: Bool
    let x: Double
    let y: Double

    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        logo = json["logo"].stringValue
        description = json["description"].stringValue
        phone = json["phone"].stringValue
        ratingNumber = json["startRatings"].doubleValue
        ratings = json["rantings"].intValue
        isFavourite = json["isFauvorite"].boolValue
        for image in json["imageShops"].arrayValue {
            self.images.append(image.stringValue)
        }

        city = json["city"].stringValue
        disctrict = json["disctrict"].stringValue
        town = json["town"].stringValue
        street = json["street"].stringValue
        x = json["x"].doubleValue
        y = json["y"].doubleValue
    }
}
