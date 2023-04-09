import UIKit

final class ListHotVoucherViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var baseTableView: BaseTableView!
    
    // MARK: - Public Variable
    
    var hotVouchers: [VoucherModel] = [] {
        didSet {
            if baseTableView != nil {
                baseTableView.reloadData()
            }
        }
    }
    
    private let statusType: StatusVoucher = .inactive
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func applyLocalization() {
        title = "Hot Voucher"
    }
}

// MARK: - Private

private extension ListHotVoucherViewController {
    func setupUI() {
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)

        baseTableView.delegate = self
        baseTableView.dataSource = self
        baseTableView.register(SafeFoodVoucherRow.self)
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
        cell.timeApplyText = vouchers.status == statusType ? "\(vouchers.endedAt)" : nil
        cell.isShowUpcomingView = vouchers.status == statusType ? false : true
    }
}

// MARK: - UITableViewDataSource

extension ListHotVoucherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotVouchers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SafeFoodVoucherRow.self)
        setupData(for: cell, vouchers: hotVouchers[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListHotVoucherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = DetailVoucherViewController.makeMe()
            vc.voucherId = hotVouchers[indexPath.row].id
            pushViewController(vc, animated: true )
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
