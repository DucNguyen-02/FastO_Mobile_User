//
//  ImageFolderType.swift
//  SafeFood Shop
//
//  Created by Lê Kim Hoàng on 11/1/22.
//

import Foundation

enum ImageFolderType {
    case product
    case shop
    case voucher
    case user
    case category
    case bill
    case news
    case community

    var type: String {
        switch self {
        case .product:
            return "PRODUCT"
        case .shop:
            return "SHOP"
        case .voucher:
            return "VOUCHER"
        case .user:
            return "USER"
        case .category:
            return "CATEGORY"
        case .bill:
            return "BILL"
        case .news:
            return "NEWS"
        case .community:
            return "COMMUNITY"
        }
    }
}
