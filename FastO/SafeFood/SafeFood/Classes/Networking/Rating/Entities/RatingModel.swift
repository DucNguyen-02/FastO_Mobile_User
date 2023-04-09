//
//  RatingModel.swift
//  AppPass
//
//  Created by Zipris on 28/11/2022.
//

import Foundation

struct RatingModel {
    let billId: Int
    let shopId: Int
    let content: String?
    let rating: Int
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["billId"] = billId
        dict["shopId"] = shopId
        dict["start"] = rating
        
        if content != nil {
            dict["content"] = content
        }
        return dict
    }
}
