//
//  CreateOrderModel.swift
//  SafeFood
//
//  Created by ADMIN on 19/11/2022.
//

import Foundation
import SwiftyJSON

struct VoucherApplyModel {
    var orderDetails: [OrderDetail]
    var shopId: Int
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["shopId"] = shopId
        
        var orders = [[String: Any]]()
        for order in orderDetails {
            let product = order.toDictionary()
            orders.append(product)
        }
        dict["orderDetails"] = orders
        return dict
    }
}

struct OrderDetail {
    let amount: Int
    let productId: Int
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["amount"] = amount
        dict["productId"] = productId
        return dict
    }
}
