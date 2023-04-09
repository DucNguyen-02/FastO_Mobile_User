//
//  CommunityModel.swift
//  SafeFood
//
//  Created by Zipris on 23/11/2022.
//

import Foundation
import SwiftyJSON

struct CommunityModel {
    let id: Int
    let title: String
    let content: String
    let createdAt: String
    var images: [String] = []
    let isLiked: Bool
    let totalFavorite: Int
    let totalComment: Int
    var shop: ShopCommunityModel
    var user: UserReviewModel
    
    init(json: JSON) {
        id = json["id"].intValue
        title = json["title"].stringValue
        content = json["content"].stringValue
        createdAt = json["createdAt"].stringValue
        isLiked = json["isLiked"].boolValue
        totalFavorite = json["totalFavorite"].intValue
        totalComment = json["totalReply"].intValue
        shop = ShopCommunityModel(json: json["shop"])
        user = UserReviewModel(json: json["user"])
        for img in json["images"].arrayValue {
            self.images.append(img.stringValue)
        }
    }
}
