import UIKit

final class SearchListVoucherViewController: BaseViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: BaseTableView!

    // MARK: - Public Variable

    var listVoucher: [VoucherModel] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func applyLocalization() {
        title = "List Voucher"
    }
}

// MARK: - Private

private extension SearchListVoucherViewController {
    func setupUI() {
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SafeFoodVoucherRow.self)
    }

    func setupDataVoucher(cell: SafeFoodVoucherRow, vouchers: VoucherModel) {
        cell.name = vouchers.name
        cell.descriptionText = vouchers.description
        cell.urlString = vouchers.image
        cell.numberCount = nil
        cell.currentPrice = nil
        cell.soldCountText = vouchers.status != .inactive ? "Used to \(vouchers.countUserVoucher) vouchers" : nil
        cell.discount = vouchers.valueDiscount
        cell.isHidden = listVoucher.isEmpty
        cell.discountType = vouchers.voucherType == .percent ? "%" : "VNĐ"
        cell.timeApplyText = vouchers.status == .inactive ? "Start at \(vouchers.createAt)" : nil
        cell.isShowUpcomingView = vouchers.status != .inactive
    }

    func convertDataTime(withFormat format: Date ) -> String {
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

// MARK: - UITableViewDataSource

extension SearchListVoucherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVoucher.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SafeFoodVoucherRow.self, for: indexPath)
        setupDataVoucher(cell: cell, vouchers: listVoucher[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchListVoucherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailVoucherViewController.makeMe()
        vc.voucherId = listVoucher[indexPath.row].id
//        vc.statusType = listVoucher[indexPath.row].status
        pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
