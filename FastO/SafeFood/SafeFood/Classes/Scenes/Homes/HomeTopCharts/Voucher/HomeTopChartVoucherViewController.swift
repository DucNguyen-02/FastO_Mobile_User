import UIKit

final class HomeTopChartVoucherViewController: BaseViewController {
    
    struct Constants {
        static let numberItems: Int = 4
        static let cellHeight: CGFloat = 90
        static let bottomPadding: CGFloat = 16
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: BaseTableView!
    
    // MARK: - Public Variable
    
    var topVouchers: [VoucherModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Private Variable
    
    private let type: VoucherType = .percent
    private let statusType: StatusVoucher = .inactive
    
    // MARK: - LifeCyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
// MARK: - Private

private extension HomeTopChartVoucherViewController {
    func setupUI() {
        tableView.register(SafeFoodVoucherRow.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupData(cell: SafeFoodVoucherRow, topVouchers: VoucherModel, index: IndexPath) {
        cell.name = topVouchers.name
        cell.descriptionText = topVouchers.description
        cell.urlString = topVouchers.image
        cell.numberCount = "\(index.row + 1)"
        cell.currentPrice = nil
        cell.soldCountText = topVouchers.status == statusType ? nil : "Used to \(topVouchers.countUserVoucher) people"
        cell.discount = topVouchers.valueDiscount
        cell.isHidden = self.topVouchers.isEmpty
        cell.discountType = topVouchers.voucherType == type ? "%" : "VNĐ"
        cell.isShowPercentImage = topVouchers.voucherType == type ? false : true
        cell.timeApplyText = topVouchers.status == statusType ? "\(topVouchers.createAt)" : nil
        cell.isShowUpcomingView = topVouchers.status == statusType ? false : true
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

extension HomeTopChartVoucherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topVouchers.count > Constants.numberItems ? Constants.numberItems : topVouchers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SafeFoodVoucherRow.self)
        setupData(cell: cell, topVouchers: topVouchers[indexPath.row], index: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeTopChartVoucherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController {
            let vc = DetailVoucherViewController.makeMe()
            vc.voucherId = topVouchers[indexPath.row].id
            topVC.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight + Constants.bottomPadding
    }
}
