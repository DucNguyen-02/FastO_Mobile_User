//
//  CreateBillModel.swift
//  SafeFood
//
//  Created by ADMIN on 20/11/2022.
//

import Foundation
import SwiftyJSON

struct CreateBillModel {
    var orderDetails: [OrderDetail]
    var shopId: Int
    var voucherId: Int?
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["shopId"] = shopId
        
        var orders = [[String: Any]]()
        for order in orderDetails {
            let product = order.toDictionary()
            orders.append(product)
        }
        dict["productDetailRequestDtos"] = orders
        
        if voucherId !=  nil {
            dict["voucherId"] = voucherId
        }
        return dict
    }
}
