import UIKit

final class DetailBrandVoucherView: NibView {

    struct Constants {
        static let maxCountItems: Int = 3
        static let cellHeight: CGFloat = 90
        static let bottomPadding: CGFloat = 16
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: BaseTableView!

    // MARK: - Public Variable

    var vouchers: [VoucherModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - LifeCyle

    override func configureView() {
        super.configureView()
        setupTableView()
    }
}

// MARK: - Private

private extension DetailBrandVoucherView {
    func setupTableView() {
        tableView.register(SafeFoodVoucherRow.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func setupData(for cell: SafeFoodVoucherRow, vouchers: VoucherModel) {
        cell.numberCount = nil
        cell.currentPrice = nil
        cell.name = vouchers.name
        cell.soldCountText = "Used by \(vouchers.countUserVoucher) people"
        switch vouchers.voucherType {
        case .percent:
            cell.discountType = "%"
            cell.isShowPercentImage = false
        case .amount:
            cell.discountType = "VNĐ"
            cell.isShowPercentImage = true
        }
        cell.discount = vouchers.valueDiscount
        cell.descriptionText = vouchers.description
        cell.urlString = vouchers.image
        cell.timeApplyText = vouchers.status == .inactive ? "\(vouchers.createAt)" : nil
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

extension DetailBrandVoucherView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vouchers.count > Constants.maxCountItems ? Constants.maxCountItems : vouchers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SafeFoodVoucherRow.self, for: indexPath)
        setupData(for: cell, vouchers: vouchers[indexPath.item])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DetailBrandVoucherView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController() {
            let vc = DetailVoucherViewController.makeMe()
            vc.voucherId = vouchers[indexPath.row].id
            topVC.pushViewController(vc, animated: true )
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight + Constants.bottomPadding
    }
}
