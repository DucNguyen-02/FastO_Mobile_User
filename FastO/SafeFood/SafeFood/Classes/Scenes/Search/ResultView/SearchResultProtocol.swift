import Foundation

protocol SearchResultViewInput: AnyObject {
    func reloadTableViewData()
}

protocol SearchResultViewOutput: AnyObject {
    func onViewDidLoad(with keyword: String)
}

enum SearchResultSection: Int, CaseIterable {
    case voucher = 0
    case brand

    var titleHeader: String {
        switch self {
        case .voucher:
            return "Voucher"
        case .brand:
            return "Brand"
        }
    }
}
