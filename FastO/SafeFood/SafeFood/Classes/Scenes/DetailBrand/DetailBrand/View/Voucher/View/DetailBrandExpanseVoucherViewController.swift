import UIKit

final class DetailBrandExpanseVoucherViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: BaseTableView!
    
    // MARK: - Private Variable

    private lazy var presenter: DetailBrandExpanseVoucherPresenter = {
      let presenter = DetailBrandExpanseVoucherPresenter()
      presenter.view = self
      return presenter
    }()
    
    // MARK: - Public variable
    
    var id: Int? {
        didSet {
            guard let id = id else { return }
            presenter.onViewDidLoad(with: id)
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func applyLocalization() {
        title = R.string.localizable.detail_brand_voucher.localized()
    }
}

// MARK: - Private

private extension DetailBrandExpanseVoucherViewController {
    func setupUI() {
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SafeFoodVoucherRow.self)
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

extension DetailBrandExpanseVoucherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.vouchers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SafeFoodVoucherRow.self)
        setupData(for: cell, vouchers: presenter.vouchers[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DetailBrandExpanseVoucherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailVoucherViewController.makeMe()
        vc.voucherId = presenter.vouchers[indexPath.row].id
        pushViewController(vc, animated: true )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - DetailBrandExpanseVoucherViewInput

extension DetailBrandExpanseVoucherViewController: DetailBrandExpanseVoucherViewInput {
    func reloadData() {
        tableView.reloadData()
    }
}
