import Foundation

protocol SearchInitialViewInput: AnyObject {
    func reloadTableViewData()
}

protocol SearchInitialViewOutput: AnyObject {
    func onViewDidLoad(_ latitude: Double, _ longitude: Double)
}

enum SearchInitialSection: Int, CaseIterable {
    case nearLocation
    case hotVoucher

    var titleHeader: String {
        switch self {
        case .nearLocation:
            return "Location near you"
        case .hotVoucher:
            return "Hot voucher"
        }
    }
}
