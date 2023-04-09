import Foundation

protocol DetailBrandViewInput: AnyObject {
    func updateUI()
}

protocol DetailBrandViewOutput: AnyObject {
    func onViewDidLoad(with brandId: Int)
    func onAddBrandFavourite(brandId: Int)
    func onDeleteBrandFavourite(brandId: Int)
}


protocol DetailBrandDelegate: AnyObject {
    func likeBrand(isLike: Bool)
}
