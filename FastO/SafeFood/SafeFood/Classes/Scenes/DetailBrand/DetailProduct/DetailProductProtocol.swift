import Foundation

enum ProductScreenType: Int, CaseIterable {
    case menu = 0
    case recommend
}

protocol DetailProductViewInput: AnyObject {
    func reloadData()
}

protocol DetailProductViewOutput: AnyObject {
    func onViewDidLoad(with productId: Int)
}

