//
//  ChooseVoucherViewController.swift
//  SafeFood
//
//  Created by ADMIN on 19/11/2022.
//  
//

import UIKit

final class ChooseVoucherViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var continueButton: BaseButton!
    @IBOutlet private weak var tableView: BaseTableView!
    
    // MARK: - Private Variable
    
    private var model: VoucherApplyModel?
    private var voucherId: Int?
    private lazy var presenter: ChooseVoucherPresenter = {
      let presenter = ChooseVoucherPresenter()
      presenter.view = self
      return presenter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - IBAction
    
    @IBAction private func continueButtonTapped(_ sender: Any) {
        presenter.onCreateBill(createParams())
    }
}

// MARK: - Private

private extension ChooseVoucherViewController {
    func setupUI() {
        hasNavigationBar = true
        title = "Voucher Apply For Bill"
        tableView.register(SafeFoodVoucherApplyRow.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func createParams() -> [String: Any] {
        guard let model = model  else { return [:] }
        let create = CreateBillModel(orderDetails: model.orderDetails, shopId: model.shopId, voucherId: voucherId)
        return create.toDictionary()
    }
}

// MARK: - Public

extension ChooseVoucherViewController {
    func setupData(with model: VoucherApplyModel) {
        self.model = model
        presenter.onViewDidLoad(model.toDictionary())
    }
}

// MARK: - UITableViewDataSource

extension ChooseVoucherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.vouchers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SafeFoodVoucherApplyRow.self)
        cell.setupData(voucher: presenter.vouchers[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChooseVoucherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        voucherId = presenter.vouchers[indexPath.row].id
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - ChooseVoucherViewInput

extension ChooseVoucherViewController: ChooseVoucherViewInput {
    func reloadTableViewData() {
        tableView.reloadData()
    }
    
    func moveDetailOrder(billId: Int) {
        if let topVC = UIViewController.topViewController() {
            let vc = DetailBillViewController()
            vc.billId = billId
            topVC.pushViewController(vc, animated: true)
        }
    }
}
