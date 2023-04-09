//
//  CreateCommunityModel.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/25/22.
//

import Foundation
import SwiftyJSON

struct CreateCommunityModel {
    let shopId: Int
    let content: String
    var reviewImages: [String] = []
    let title: String

    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["shopId"] = shopId
        dict["content"] = content
        dict["reviewImages"] = reviewImages
        dict["title"] = title
        return dict
    }
}

