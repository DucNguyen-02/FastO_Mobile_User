import Foundation

enum BillSection: Int, CaseIterable {
    case customer = 0
    case product
    case voucher
    case payment
    case rating

    var headerTitle: String? {
        switch self {
        case .customer:
            return "Brand"
        case .product:
            return "Detal Order"
        case .voucher:
            return "Voucher"
        case .payment:
            return "Payment"
        case .rating:
            return "Service Review"
        }
    }

    var footerTitle: String? {
        switch self {
        case .product:
            return "Total payment before discount: "
        default:
            return nil
        }
    }
}


import Foundation

protocol DetailBillViewInput: AnyObject {
    func reloadData()
    func reloadTableViewData()
    func showPopupQRCode()
}

protocol DetailBillViewOutput: AnyObject {
    func onViewDidLoad(id: Int, isShowQR: Bool)
}


protocol DetailBrandOrderDelegate: AnyObject {
    func didRating()
}
