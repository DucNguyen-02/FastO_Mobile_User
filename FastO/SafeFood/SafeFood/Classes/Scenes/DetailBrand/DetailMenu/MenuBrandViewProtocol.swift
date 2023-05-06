
import Foundation

protocol MenuBrandViewInput: AnyObject {
    func reloadTableViewData()
}

protocol MenuBrandViewOutput: AnyObject {
    func onViewDidLoad(shopId: Int)
    func onPostCart(_ params: [String: Any])
}

protocol MenuBrandDelegate: AnyObject {
    func totalProduct(number: Int, productId: Int, quantity: Int, price: Int)
    func totalDetailProduct(productId: Int, changeQuantity: Int, quantity: Int, price: Int)
}
