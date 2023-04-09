//
//  DetailBillModel.swift
//  SafeFood
//
//  Created by Zipris on 27/11/2022.
//

import Foundation
import SwiftyJSON

enum BillStatus: String {
    case create = "CREATED"
    case pending = "PENDING"
    case payment = "PAYMENTED"
    case done = "DONE"
    case fail = "FAILED"
}

struct DetailBillModel {
    let billId: Int
    let addressId: Int
    let city: String
    let code: String
    let createdAt: TimeInterval
    let district: String
    let expiredDate: String
    let isRating: Bool
    let logo: String
    let paymentType: String
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
    var userType: UserType = .shop
    let valueDiscount: Int
    let valueNeed: Int
    let voucherDiscountImage: String
    let voucherCreatedAt: TimeInterval
    let voucherEndedAt: TimeInterval
    let voucherId: Int
    let voucherName: String
    var voucherType: VoucherType = .percent
    let x: Double
    let y: Double
    var orderDetail: [DetailBillProductModel] = []
    
    init(json: JSON) {
        billId = json["billId"].intValue
        addressId = json["addressId"].intValue
        city = json["city"].stringValue
        code = json["code"].stringValue
        district = json["district"].stringValue
        isRating = json["isRating"].boolValue
        logo = json["logo"].stringValue
        paymentType = json["paymentType"].stringValue
        ratings = json["rating"].intValue
        shopId = json["shopId"].intValue
        shopName = json["shopName"].stringValue
        street = json["street"].stringValue
        totalOrigin = json["totalOrigin"].intValue
        totalDiscount = json["totalDiscount"].intValue
        totalPayment = json["totalPayment"].intValue
        town = json["town"].stringValue
        userFirstName = json["userFirstName"].stringValue
        userId = json["userId"].intValue
        userLastName = json["userLastName"].stringValue
        valueDiscount = json["valueDiscount"].intValue
        valueNeed = json["valueNeed"].intValue
        voucherDiscountImage = json["voucherDiscountImage"].stringValue
        voucherId = json["voucherId"].intValue
        voucherName = json["voucherName"].stringValue
        x = json["x"].doubleValue
        y = json["y"].doubleValue
        
        self.userType = json["userType"].stringValue ==  UserType.shop.rawValue ? .shop : .admin
        
        self.voucherType = json["voucherType"].stringValue == VoucherType.percent.rawValue ? .percent : .amount
        
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
        
        let createdAtString = json["createdAt"].stringValue
        createdAt = TimeInterval(createdAtString) ?? 0
        
        expiredDate = json["expiredDate"].stringValue
        
        let voucherCreatedAtString = json["voucherCreatedAt"].stringValue
        voucherCreatedAt = TimeInterval(voucherCreatedAtString) ?? 0
        
        let voucherEndedAtString = json["voucherEndedAt"].stringValue
        voucherEndedAt = TimeInterval(voucherEndedAtString) ?? 0
        
        for product in json["billItemResponseDtos"].arrayValue {
            self.orderDetail.append(DetailBillProductModel(json: product))
        }
    }
}
