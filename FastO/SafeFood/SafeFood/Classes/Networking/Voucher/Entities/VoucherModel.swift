//
//  VoucherModel.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/15/22.
//

import Foundation
import SwiftyJSON

enum VoucherType: String {
    case percent = "PERCENT"
    case amount = "AMOUNT"
}

enum StatusVoucher: String {
    case delete = "DELETED"
    case active = "ACTIVED"
    case inactive = "INACTIVE"
}

enum UserType: String {
    case admin = "admin"
    case shop = "shop"
}

struct VoucherModel {
    let id: Int
    let name: String
    let createAt: String
    let endedAt: String
    let deleteFlag: Bool
    let countUserVoucher: Int
    let description: String
    let image: String
    let limitPerUser: Int
    let maxDiscount: Int
    let quantity: Int
    let shopId: Int
    let shopName: String
    let status: StatusVoucher
    let userType: UserType
    let valueDiscount: Int
    let valueNeed: Int
    let voucherType: VoucherType

    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        createAt = json["createdAt"].stringValue
        endedAt = json["endedAt"].stringValue
        deleteFlag = json["deleteFlag"].boolValue
        countUserVoucher = json["countUserVoucher"].intValue
        description = json["description"].stringValue
        image = json["image"].stringValue
        limitPerUser = json["limitPerUser"].intValue
        maxDiscount = json["maxDiscount"].intValue
        quantity = json["quantity"].intValue
        shopId = json["shopId"].intValue
        shopName = json["shopName"].stringValue
        valueNeed = json["valueNeed"].intValue
        valueDiscount = json["valueDiscount"].intValue

        let voucherType = json["voucherType"].stringValue
        self.voucherType = voucherType == VoucherType.percent.rawValue ? .percent : .amount

        let userType = json["userType"].stringValue
        self.userType = userType == UserType.shop.rawValue ? .shop : .admin

        let status = json["status"].stringValue
        if status == StatusVoucher.active.rawValue {
            self.status = .active
        } else if status == StatusVoucher.inactive.rawValue {
            self.status = .inactive
        } else {
            self.status = .delete
        }
    }
}

