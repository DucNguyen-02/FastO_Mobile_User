import Foundation

protocol DetailVoucherViewInput: AnyObject {
    func reloadData()
}

protocol DetailVoucherViewOutput: AnyObject {
    func onViewDidLoad(id: Int)
}
