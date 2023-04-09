//
//  ListBillModel.swift
//  SafeFood
//
//  Created by Zipris on 27/11/2022.
//

import Foundation
import SwiftyJSON

struct ListBillModel {
    let billId: Int
    let addressId: Int
    let city: String
    let createdAt: String
    let district: String
    let isRating: Bool
    let logo: String
    let ratings: Int
    let shopId: Int
    let shopName: String
    var status: BillStatus = .create
    let street: String
    let totalOrigin: Int
    let totalDiscount: Int
    let totalPayment: Int
    let town: String
    let userFirstName: String
    let userId: Int
    let userLastName: String
    let x: Double
    let y: Double
    
    init(json: JSON) {
        billId = json["id"].intValue
        addressId = json["addressId"].intValue
        city = json["city"].stringValue
        district = json["district"].stringValue
        isRating = json["isRating"].boolValue
        logo = json["logo"].stringValue
        ratings = json["ratings"].intValue
        shopId = json["shopId"].intValue
        shopName = json["name"].stringValue
        street = json["street"].stringValue
        totalOrigin = json["totalOrigin"].intValue
        totalDiscount = json["totalDiscount"].intValue
        totalPayment = json["totalPayment"].intValue
        town = json["town"].stringValue
        userFirstName = json["userFirstName"].stringValue
        userId = json["userId"].intValue
        userLastName = json["userLastName"].stringValue
        x = json["x"].doubleValue
        y = json["y"].doubleValue
        
        let statusString = json["status"].stringValue
        if statusString == BillStatus.create.rawValue {
            self.status = .create
        } else if statusString == BillStatus.pending.rawValue {
            self.status = .pending
        } else if statusString == BillStatus.payment.rawValue {
            self.status = .payment
        } else if statusString == BillStatus.done.rawValue {
            self.status = .done
        }
        
        createdAt = json["createdAt"].stringValue
    }
}

