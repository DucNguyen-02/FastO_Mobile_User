//
//  CommentCommunityModel.swift
//  SafeFood
//
//  Created by Zipris on 24/11/2022.
//

import UIKit
import SwiftyJSON

struct CommentCommunityModel {
    let id: Int
    let createdAt: String
    let modifiedAt: String
    let isLiked: Bool
    let content: String
    let reviewId: Int
    let totalFavorite: Int
    var user: UserReviewModel
    
    init(json: JSON) {
        id = json["id"].intValue
        createdAt = json["createdAt"].stringValue
        modifiedAt = json["modifiedAt"].stringValue
        isLiked = json["isLiked"].boolValue
        content = json["content"].stringValue
        reviewId = json["reviewId"].intValue
        totalFavorite = json["totalFavorite"].intValue
        user = UserReviewModel(json: json["user"])
    }
}
