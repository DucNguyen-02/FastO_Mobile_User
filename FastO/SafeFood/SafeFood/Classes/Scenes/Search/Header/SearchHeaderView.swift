import UIKit

final class SearchHeaderView: UITableViewHeaderFooterView {

    // MARK: - IBOutlet

    @IBOutlet private weak var seeAllButton: BaseButton!
    @IBOutlet private weak var titleHeader: UILabel!
    @IBOutlet private weak var seeMoreView: UIView!

    // MARK: - Public Variable

    var sectionType: SearchResultSection?
    var vouchers: [VoucherModel] = []
    var products: [ProductModel] = []
    var brands: [BrandModel] = []
    var nearBrands: [BrandModel] = []

    @IBAction func seeAllButtonTapped(_ sender: Any) {
        switch sectionType {
        case .voucher:
            if let topVC = UIViewController.topViewController() {
                let vc = SearchListVoucherViewController()
                vc.listVoucher = vouchers
                topVC.pushViewController(vc, animated: true)
            }

        case .brand:
            if let topVC = UIViewController.topViewController() {
                let vc = SearchListBrandViewController()
                vc.setupData(with: brands)
                topVC.pushViewController(vc, animated: true)
            }
        case .none:
            if let topVC = UIViewController.topViewController() {
                let vc = SearchListNearLocationViewController()
                vc.setupData(with: nearBrands)
                topVC.pushViewController(vc, animated: true)
            }

        }
    }
}

// MARK: - Public

extension SearchHeaderView {
    func setupUI(title: String, isSeeAll: Bool) {
        titleHeader.text = title
        seeMoreView.isHidden = !isSeeAll
    }
}
