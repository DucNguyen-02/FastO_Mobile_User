import UIKit
import EmptyDataSet_Swift
import STPopup

final class ListVoucherViewController: BaseViewController {
    
    struct Contants {
        static let textColorBlack = R.color.black100() ?? .black
        static let textColorRed = R.color.redFF2929() ?? .red
    }
    
    // MARK: - IBOutlet
        
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public Variable
    
    var type: MyManagerType = .buyed
    
    // MARK: - Private Variable
    
    private var timer: Timer?
    private var ratingViewController: STPopupController!
    private lazy var presenter: ListVoucherPresenter = {
        let presenter = ListVoucherPresenter()
        presenter.view = self
        return presenter
    }()
}

// MARK: - LifeCyle

extension ListVoucherViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupData()
    }
}

// MARK: - Private

private extension ListVoucherViewController {
    func setupData() {
        switch type {
        case .buyed:
            presenter.getDataOrder(status: .payment, query: nil)
        case .used:
            presenter.getDataOrder(status: .done, query: nil)
        case .error:
            presenter.getDataOrder(status: .fail, query: nil)
        case .saved:
            presenter.getDataSavedBrands()
        }
    }
    
    func setupTableView() {
        tableView.register(SafeFoodOrderRow.self)
        tableView.register(SafeFoodVoucherRow.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
    }
    
    func setupTextField() {
        searchTextField.delegate = self

        searchTextField.clearButtonMode = .whileEditing
        if let clearButton = searchTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(R.image.icClose(), for: .normal)
        }
    }
    
    func setupDataSavedBrands(for cell: SafeFoodVoucherRow, savedBrands: BrandFavouriteModel ) {
        cell.name = savedBrands.name
        cell.descriptionText = savedBrands.description
        cell.urlString = savedBrands.banner
        cell.numberCount = nil
        cell.currentPrice = nil
        cell.soldCountText = nil
        cell.discount = nil
        cell.isHidden = presenter.savedBrands.isEmpty
        cell.discountType = nil
        cell.isShowPercentImage = nil
        cell.timeApplyText = nil
        cell.isShowUpcomingView = nil

    }
    
    func setupDataMyOrder(for cell: SafeFoodOrderRow, orders: ListBillModel) {
        cell.name = orders.shopName
        cell.imageUrl = orders.logo
        cell.descriptionText = "Address \(orders.street + ", " + orders.city)"
        cell.priceText = "\(formatToString(number: orders.totalPayment))VNĐ"
        cell.timeText = orders.createdAt
        cell.isHidden = presenter.listBill.isEmpty
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
    
    func showRatingPopup(_ index: Int) {
        guard let topVC = UIViewController.topViewController else {return}
        let order = presenter.listBill[index]
        let vc = RatingViewController.makeMe()
        vc.delegate = self
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
    
    @objc func performSearch() {
        if let text = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if text.isEmpty {
                switch type {
                case .buyed:
                    presenter.getDataOrder(status: .payment, query: nil)
                case .used:
                    presenter.getDataOrder(status: .done, query: nil)
                case .error:
                    presenter.getDataOrder(status: .fail, query: nil)
                case .saved:
                    presenter.getDataSavedBrands()
                }
            } else {
                switch type {
                case .buyed:
                    presenter.getDataOrder(status: .payment, query: text)
                case .used:
                    presenter.getDataOrder(status: .done, query: text)
                case .error:
                    presenter.getDataOrder(status: .fail, query: text)
                case .saved:
                    presenter.getDataSavedBrands()
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ListVoucherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .buyed, .used, .error:
            return presenter.listBill.count
    
        case .saved:
            return presenter.savedBrands.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .buyed:
            let cell = tableView.dequeue(SafeFoodOrderRow.self, for: indexPath)
            cell.isRepurchase = true
            cell.colorText(colorNametext: Contants.textColorBlack,
                           colorPriceText: Contants.textColorBlack)
            cell.isShowBlurView = true
            setupDataMyOrder(for: cell, orders: presenter.listBill[indexPath.row])
            return cell
            
        case .used:
            let cell = tableView.dequeue(SafeFoodOrderRow.self, for: indexPath)
            let order = presenter.listBill[indexPath.row]
            cell.isShowBlurView = false
            cell.delegate = self
            cell.rateView(rating: order.ratings, isRating: order.isRating, index: indexPath.row)
            setupDataMyOrder(for: cell, orders: order)
            return cell
            
        case .error:
            let cell = tableView.dequeue(SafeFoodOrderRow.self, for: indexPath)
            cell.isRepurchase = true
            cell.isShowBlurView = true
            cell.colorText(colorNametext: Contants.textColorBlack,
                           colorPriceText: Contants.textColorRed)
            setupDataMyOrder(for: cell, orders: presenter.listBill[indexPath.row])
            cell.timeText = nil
            return cell
            
        case .saved:
            let cell = tableView.dequeue(SafeFoodVoucherRow.self, for: indexPath)
            setupDataSavedBrands(for: cell, savedBrands: presenter.savedBrands[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ListVoucherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case .buyed, .used:
            if let topVC = UIViewController.topViewController() {
                let vc = DetailBillViewController()
                vc.billId = presenter.listBill[indexPath.item].billId
                vc.isHideButton = true
                vc.isSuccess = true
                topVC.pushViewController(vc, animated: true)
            }

        case .error:
            if let topVC = UIViewController.topViewController() {
                let vc = DetailBillViewController()
                vc.billId = presenter.listBill[indexPath.item].billId
                vc.isHideButton = false
                vc.isSuccess = false
                topVC.pushViewController(vc, animated: true)
            }

        case .saved:
            if let topVC = UIViewController.topViewController {
                let vc = DetailBrandViewController.makeMe()
                vc.brandId = presenter.savedBrands[indexPath.row].shopId
                topVC.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension ListVoucherViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let keyword = textField.text.orEmpty
        switch type {
        case .buyed:
            presenter.getDataOrder(status: .payment, query: keyword)
        case .used:
            presenter.getDataOrder(status: .done, query: keyword)
        case .error:
            presenter.getDataOrder(status: .fail, query: keyword)
        case .saved:
            presenter.getDataSavedBrands()
        }
        searchTextField.resignFirstResponder()
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        switch type {
        case .buyed:
            presenter.getDataOrder(status: .payment, query: nil)
        case .used:
            presenter.getDataOrder(status: .done, query: nil)
        case .error:
            presenter.getDataOrder(status: .fail, query: nil)
        case .saved:
            presenter.getDataSavedBrands()
        }
        return true
    }
}

// MARK: - EmptyDataSetSource

extension ListVoucherViewController: EmptyDataSetSource {
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return type.titleEmpty
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return type.imageEmpty
    }
}


extension ListVoucherViewController: ListVoucherDelegate {
    func showRating(_ index: Int) {
        showRatingPopup(index)
    }

    func reloadData() {
        presenter.getDataOrder(status: .done, query: nil)
    }
}


// MARK: - MyVoucherViewInput

extension ListVoucherViewController: ListVoucherViewInput {
    func reloadTableviewData() {
        tableView.reloadData()
    }
}
