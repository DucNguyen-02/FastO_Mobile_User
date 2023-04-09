//
//  DetailBillViewController.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/6/22.
//

import UIKit
import STPopup

final class DetailBillViewController: BaseViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var titleScreenLabel: UILabel!
    @IBOutlet private weak var totalQuantityLabel: UILabel!
    @IBOutlet private weak var totalPaymentLabel: UILabel!
    @IBOutlet private weak var totalDiscountLabel: UILabel!
    @IBOutlet private weak var orderButton: BaseButton!
    @IBOutlet private weak var tableView: BaseTableView!
    @IBOutlet private weak var qrButton: BaseButton!
    
    // MARK: - Private Variable
    
    private var ratingViewController: STPopupController!
    private var QRPopupViewController: STPopupController!
    private lazy var presenter: DetailBillPresenter = {
        let presenter = DetailBillPresenter()
        presenter.view = self
        return presenter
    }()
    

    // MARK: - Public Variable
    
    var billId: Int?
    var isSuccess: Bool = false
    var isHideButton: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        guard let billId = billId else { return }
        presenter.onViewDidLoad(id: billId, isShowQR: false)
    }

    // MARK: - IBAction

    @IBAction private func backButtonTapped(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction private func qrButtonTapped(_ sender: Any) {
        guard let orderId = billId else { return }
        presenter.onViewDidLoad(id: orderId, isShowQR: true)
    }
    
    @IBAction private func useButtonTapped(_ sender: Any) {
        if isSuccess {
            OrderManagementActionButton()
        } else {
            guard let billId = billId else { return }
            presenter.onOrderButtonTappedWithVnPay(requestModel:VNPaymentRequestModel(
                bankCode: APIConstant.vnPayBankCode,
                billId: billId,
                vnpLocale: APIConstant.vnPayLocale,
                vnpOderType: APIConstant.vnPayOderType,
                vnpReturnUrl: APIConstant.vnpayRedirectUrl))
        }
    }
}

// MARK: - Private

private extension DetailBillViewController {
    func setupUI() {
        qrButton.isHidden = !isSuccess
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(DetailBillHeaderView.self)
        tableView.register(CustomerBillCell.self)
        tableView.register(ProductBillCell.self)
        tableView.register(VoucherBillCell.self)
        tableView.register(PaymentBillCell.self)
        tableView.register(RatingOrderCell.self)
    }
    
    func OrderManagementActionButton() {
        let vc = TabBarViewController()
        vc.selectedIndex = 1
        guard let tabBarItems = vc.tabBar.items else { return }
        let tabBar = TabBarType(rawValue: 1)
        tabBarItems.enumerated().forEach {
            if $0.offset == tabBar?.rawValue {
                $0.element.title = tabBar?.title
            } else {
                $0.element.title = ""
            }
        }
        pushViewController(vc, with: .revealFromBottom)
    }
    
    func showQRPopup(code: String, expiredDate: String, used: Bool) {
        let vc = QRViewController()
        vc.code = code
        vc.expiredDate = expiredDate
        vc.used = used
        vc.contentSizeInPopup = QRViewController.Constants.viewSize
        
        let popupController = STPopupController(rootViewController: vc)
        popupController.navigationBar.isHidden = true
        popupController.transitionStyle = .slideVertical
        popupController.containerView.layer.cornerRadius = 18
        popupController.containerView.backgroundColor = R.color.white100() ?? .white
        popupController.safeAreaInsets.bottom = 0
        popupController.style = .bottomSheet
        popupController.backgroundView?.backgroundColor = R.color.black060606() ?? .black
        popupController.backgroundView?.alpha = 0.7
        popupController.present(in: self)

        QRPopupViewController = popupController
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        QRPopupViewController.backgroundView?.addGestureRecognizer(tapGesture)
    }

    @objc func didTapBackgroundView() {
        QRPopupViewController.dismiss()
    }
    
    func showRatingPopup() {
        guard let topVC = UIViewController.topViewController, let order = presenter.order else {return}

        let vc = RatingViewController.makeMe()
        vc.setupData(billId: order.billId, shopId: order.shopId, shopName: order.shopName)
        vc.contentSizeInPopup = RatingViewController.Constants.viewSize

        let popupController = STPopupController(rootViewController: vc)
        popupController.navigationBar.isHidden = true
        popupController.transitionStyle = .slideVertical
        popupController.containerView.layer.cornerRadius = 0
        popupController.containerView.backgroundColor = .clear
        popupController.safeAreaInsets.bottom = 0
        popupController.style = .bottomSheet
        popupController.backgroundView?.backgroundColor = R.color.black060606() ?? .black
        popupController.backgroundView?.alpha = 0.7
        popupController.present(in: topVC, completion: nil)

        ratingViewController = popupController
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ratingDidTapBackgroundView))
        ratingViewController.backgroundView?.addGestureRecognizer(tapGesture)
    }

    @objc func ratingDidTapBackgroundView() {
        ratingViewController.dismiss()
    }

    func setupOrderSuccess(isSuccess: Bool, isHide: Bool) {
        qrButton.isHidden = !isSuccess
        self.isSuccess = isSuccess
        orderButton.isHidden = isSuccess && isHide
    }
}

// MARK: - UITableViewDataSource

extension DetailBillViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return BillSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = BillSection(rawValue: section), let order = presenter.order else { return 0 }
        switch sectionType {
        case .customer, .payment:
            return 1
        case .product:
            return order.orderDetail.count
        case .voucher:
            return 1
        case .rating:
            return order.status == .done ? 1 : 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = BillSection(rawValue: indexPath.section), let order = presenter.order else { return UITableViewCell() }
        switch sectionType {
        case .customer:
            let cell = tableView.dequeue(CustomerBillCell.self, for: indexPath)
            cell.setupData(bill: order)
            return cell

        case .product:
            let cell = tableView.dequeue(ProductBillCell.self, for: indexPath)
            let product = order.orderDetail[indexPath.row]
            cell.imageURL = product.image
            cell.name = product.nameProduct
            cell.quantity = product.amount
            cell.price = product.price
            return cell

        case .voucher:
            let cell = tableView.dequeue(VoucherBillCell.self, for: indexPath)
            cell.name = order.voucherName
            cell.imageURL = order.voucherDiscountImage
            cell.discount(type: order.voucherType, discount: order.valueDiscount)
            return cell

        case .payment:
            let cell = tableView.dequeue(PaymentBillCell.self, for: indexPath)
            return cell
            
        case .rating:
            let cell = tableView.dequeue(RatingOrderCell.self)
            cell.delegate = self
            cell.setupData(rating: Double(order.ratings))
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension DetailBillViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = BillSection(rawValue: section) else { return nil }
        let headerView = tableView.dequeue(DetailBillHeaderView.self)
        headerView.title = sectionType.headerTitle
        headerView.line = sectionType == .customer
        headerView.value = nil
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let sectionType = BillSection(rawValue: section) else { return nil }
        switch sectionType {
        case .customer, .payment, .voucher, .rating:
            return nil
        case .product:
            let footerView = tableView.dequeue(DetailBillHeaderView.self)
            guard let order = presenter.order else { return nil }
            footerView.title = sectionType.footerTitle
            footerView.line = true
            footerView.value = order.totalOrigin
            return footerView
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = BillSection(rawValue: section), let order = presenter.order else { return .leastNormalMagnitude }
        switch sectionType {
        case .rating:
            return order.status == .done ? 36 : .leastNormalMagnitude
        default:
            return 36
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let sectionType = BillSection(rawValue: section), let order = presenter.order else { return .leastNormalMagnitude }
        switch sectionType {
        case .product:
            return 44
        case .rating:
            return order.status == .done ? 44 : .leastNormalMagnitude
        default:
            return .leastNormalMagnitude
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = BillSection(rawValue: indexPath.section), let order = presenter.order else { return 0 }
        switch sectionType {
        case .rating:
            return order.status == .done ? UITableView.automaticDimension : 0
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: - DetailBrandOrderDelegate

extension DetailBillViewController: DetailBrandOrderDelegate {
    func didRating() {
        showRatingPopup()
    }
}

// MARK: - DetailBillViewInput

extension DetailBillViewController: DetailBillViewInput {
    func reloadData() {
        
    }
    
    func reloadTableViewData() {
        guard let order = presenter.order else { return }
        totalQuantityLabel.text = "\(order.orderDetail.count)" + "product"
        totalDiscountLabel.text = formatToString(number: order.totalDiscount) + "VNĐ"
        totalPaymentLabel.text = formatToString(number: order.totalPayment) + "VNĐ"
        if let order = presenter.order, order.status == .payment || order.status == .done  {
            setupOrderSuccess(isSuccess: true, isHide: isHideButton)
        } else {
            setupOrderSuccess(isSuccess: false, isHide: false)
        }
        tableView.reloadData()
    }
    
    func showPopupQRCode() {
        qrButton.isHidden = false
        orderButton.isHidden = isSuccess && isHideButton
        orderButton.setTitle("My Manager", for: .normal)
        guard let order = presenter.order else { return }
        showQRPopup(code: order.code, expiredDate: order.expiredDate, used: order.status == .done)
    }
}
