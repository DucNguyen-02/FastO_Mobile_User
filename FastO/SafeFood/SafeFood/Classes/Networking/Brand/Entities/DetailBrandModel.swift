//
//  DetailBrandModel.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/16/22.
//

import Foundation
import SwiftyJSON

struct DetailBrandModel {
    let shopProfile: ProfileBrandModel
    var listProduct: [ProductModel] = []
    var listVoucher: [VoucherModel] = []

    init(json: JSON) {
        self.shopProfile = ProfileBrandModel(json: json["shopProfile"])

        for product in json["listProduct"].arrayValue {
            self.listProduct.append(ProductModel(json: product))
        }

        for voucher in json["listVoucher"].arrayValue {
            self.listVoucher.append(VoucherModel(json: voucher))
        }
    }
}
