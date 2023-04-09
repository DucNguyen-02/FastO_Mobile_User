//
//  ProductModel.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/15/22.
//

import Foundation
import SwiftyJSON

enum StatusProduct: String {
    case new = "NEW"
    case hot = "HOT"
    case recommend = "RECOMMEND"
}

struct ProductModel {
    let id: Int
    let name: String
    let image: String
    let description: String
    let countPay: Int
    let price: Int
    let status: StatusProduct
    let categoryId: Int
    let categoryName: String
    let shopId: Int
    let shopName: String

    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        image = json["image"].stringValue
        description = json["description"].stringValue
        countPay = json["countPay"].intValue
        price = json["price"].intValue
        categoryId = json["categoryId"].intValue
        categoryName = json["categoryName"].stringValue
        shopId = json["shopId"].intValue
        shopName = json["shopName"].stringValue

        let status = json["status"].stringValue
        if status == StatusProduct.new.rawValue {
            self.status = .new
        } else if status == StatusProduct.hot.rawValue {
            self.status = .hot
        } else {
            self.status = .recommend
        }
    }
}
