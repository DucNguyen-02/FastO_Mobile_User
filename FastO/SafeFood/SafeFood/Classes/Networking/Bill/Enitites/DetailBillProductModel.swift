//
//  DetailBillProductModel.swift
//  SafeFood
//
//  Created by Zipris on 27/11/2022.
//

import Foundation
import SwiftyJSON

struct DetailBillProductModel {
    let amount: Int
    let image: String
    let nameCategory: String
    let nameProduct: String
    let nameShop: String
    let price: Int
    
    init(json: JSON) {
        amount = json["amount"].intValue
        image = json["image"].stringValue
        nameCategory = json["nameCategory"].stringValue
        nameProduct = json["nameProduct"].stringValue
        nameShop = json["nameShop"].stringValue
        price = json["price"].intValue
    }
}
