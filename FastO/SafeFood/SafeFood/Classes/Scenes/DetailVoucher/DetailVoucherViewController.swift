import UIKit

final class DetailVoucherViewController: BaseViewController {
    
    // MARK: - IBOutlet

    @IBOutlet private weak var voucherImageView: BaseImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueDiscountLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var applyLabel: UILabel!
    @IBOutlet private weak var createdByLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var detailVoucherLabel: UILabel!

    // MARK: - Private Variable
    
    private lazy var presenter: DetailVoucherPresenter = {
      let presenter = DetailVoucherPresenter()
      presenter.view = self
      return presenter
    }()

    // MARK: - Public Variable

    var voucherId: Int? {
        didSet {
            guard let id = voucherId else { return }
            presenter.onViewDidLoad(id: id)
        }
    }

    // MARK: - IBAction

    @IBAction private func backButtonTapped(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction private func goToShopButtonTapped(_ sender: Any) {
        guard let voucher = presenter.voucher else { return }
    
        if voucher.userType == .admin {
            if let topVC = UIViewController.topViewController() {
                let vc = ListBrandApplyVoucherViewController.makeMe()
                topVC.pushViewController(vc, animated: true)
            }
        } else {
            if let topVC = UIViewController.topViewController() {
                let vc = DetailBrandViewController.makeMe()
                vc.brandId = voucher.shopId
                topVC.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - Private

private extension DetailVoucherViewController {
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

// MARK: - DetailVoucherViewInput

extension DetailVoucherViewController: DetailVoucherViewInput {
    func reloadData() {
        guard let voucher = presenter.voucher else { return }
        voucherImageView.setImage(with: voucher.image, placeholderImage: R.image.icPlaceholderImg())
        detailVoucherLabel.text = voucher.name
        nameLabel.text = voucher.name
        descriptionLabel.text = "Description short: \(voucher.description)"
        quantityLabel.text = "Quantity voucher: \(voucher.quantity) vouchers"
        applyLabel.text = "Apply for bill from \(formatToString(number: voucher.valueNeed))VNĐ, discount maximum is \(formatToString(number: voucher.maxDiscount))VNĐ"
        createdByLabel.text = "Voucher created by \(voucher.userType.rawValue)"
        timeLabel.text = "Voucher apply from \(voucher.createAt) - \(voucher.endedAt)"
        let abc = voucher.voucherType == .amount ? "VNĐ" : "%"
        valueDiscountLabel.text = "-\(formatToString(number: voucher.valueDiscount))" + abc
    }
}
