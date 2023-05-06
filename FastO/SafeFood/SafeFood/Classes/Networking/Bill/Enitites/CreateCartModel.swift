import Foundation
import SwiftyJSON

struct CreateCartModel {
    var cartDtos: [ProductCartDetail]
    var shopId: Int

    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["shopId"] = shopId

        var orders = [[String: Any]]()
        for order in cartDtos {
            let product = order.toDictionary()
            orders.append(product)
        }
        dict["cartDtos"] = orders
        return dict
    }
}

struct ProductCartDetail {
    let amount: Int
    let productId: Int
    let image: String
    let name: String
    let price: Double
    let shopId: Int

    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["amount"] = amount
        dict["id"] = productId
        dict["image"] = image
        dict["name"] = name
        dict["price"] = price
        dict["shopId"] = shopId
        return dict
    }
}
