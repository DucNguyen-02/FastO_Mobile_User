import UIKit

final class SearchResultView: NibView {

    struct Constants {
        static let heightHeader: CGFloat = 44
        static let maxNumberVoucher: Int = 3
        static let maxNumberProduct: Int = 3
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: BaseTableView!

    // MARK: - Private Variable

    private var keyword: String?
    private let type: VoucherType = .percent
    private lazy var presenter: SearchResultPresenter = {
        let presenter = SearchResultPresenter()
        presenter.view = self
        return presenter
    }()

    // MARK: - Lifecycle

    override func configureView() {
        super.configureView()
        setupUI()
    }
}

// MARK: - Private

private extension SearchResultView {
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchHeaderView.self)

        tableView.register(SafeFoodVoucherRow.self)
        tableView.register(SearchResultProductCell.self)
        tableView.register(SearchResultBrandCell.self)
    }

    func setupDataVoucher(cell: SafeFoodVoucherRow, vouchers: VoucherModel) {
        cell.name = vouchers.name
        cell.descriptionText = vouchers.description
        cell.urlString = vouchers.image
        cell.numberCount = nil
        cell.currentPrice = nil
        cell.soldCountText = vouchers.status != .inactive ? "Used to \(vouchers.countUserVoucher) vouchers" : nil
        cell.discount = vouchers.valueDiscount
        cell.isHidden = presenter.vouchers.isEmpty
        cell.discountType = vouchers.voucherType == .percent ? "%" : "VNĐ"
        cell.timeApplyText = vouchers.status == .inactive ? "Start at \(vouchers.createAt)" : nil
        cell.isShowUpcomingView = vouchers.status != .inactive
    }

    func convertDataTime(withFormat format: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: format)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = .current
        let myStringDate = formatter.string(from: yourDate!)
        return myStringDate
    }
}

// MARK: - Public

extension SearchResultView {
    func setupData(keyword: String) {
        self.keyword = keyword
        presenter.onViewDidLoad(with: keyword)
    }
}

// MARK: - UITableViewDataSource

extension SearchResultView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SearchResultSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SearchResultSection(rawValue: section) else { return 0 }

        switch sectionType {
        case .voucher:
            return presenter.vouchers.count > Constants.maxNumberVoucher ? Constants.maxNumberVoucher : presenter.vouchers.count
        case .brand:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = SearchResultSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch sectionType {
        case .voucher:
            let cell = tableView.dequeue(SafeFoodVoucherRow.self, for: indexPath)
            setupDataVoucher(cell: cell, vouchers: presenter.vouchers[indexPath.row])
            return cell
        case .brand:
            let cell = tableView.dequeue(SearchResultBrandCell.self, for: indexPath)
            cell.brands = presenter.brands
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchResultView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = SearchResultSection(rawValue: indexPath.section) else { return }
        switch sectionType {
        case .voucher:
            if let topVC = UIViewController.topViewController() {
                let vc = DetailVoucherViewController.makeMe()
                vc.voucherId = presenter.vouchers[indexPath.row].id
                topVC.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = SearchResultSection(rawValue: section) else { return nil }
        let header = tableView.dequeue(SearchHeaderView.self)
        switch sectionType {
        case .voucher:
            header.setupUI(title: sectionType.titleHeader, isSeeAll: true)
            header.sectionType = .voucher
            header.vouchers = presenter.vouchers
        case .brand:
            header.setupUI(title: sectionType.titleHeader, isSeeAll: true)
            header.sectionType = .brand
            header.brands = presenter.brands
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = SearchResultSection(rawValue: section) else { return .leastNormalMagnitude }
        switch sectionType {
        case .voucher:
            return presenter.vouchers.isEmpty ? .leastNormalMagnitude : Constants.heightHeader
        case .brand:
            return presenter.brands.isEmpty ? .leastNormalMagnitude : Constants.heightHeader
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - SearchResultViewInput

extension SearchResultView: SearchResultViewInput {
    func reloadTableViewData() {
        presenter.vouchers.isEmpty
            && presenter.brands.isEmpty ? ToastHelper.showError("Không tìm thấy kết quả nào") : nil
        tableView.reloadData()
    }
}
