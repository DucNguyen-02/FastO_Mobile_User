import Foundation

protocol ListVoucherViewInput: AnyObject, CanNavigateViewControllers {
    func reloadTableviewData()
}

protocol ListVoucherViewOutput: AnyObject {
    func getDataOrder(status: BillStatus, query: String?)
    func getDataSavedBrands()
}

protocol ListVoucherDelegate: AnyObject {
    func showRating(_ index: Int)
    func reloadData()
}
