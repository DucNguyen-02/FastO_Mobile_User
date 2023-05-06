
import UIKit

final class MenuBrandViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var quantityOfProductLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var continueButton: BaseButton!
    @IBOutlet private weak var tableView: BaseTableView!
    
    // MARK: - Private Variable

    private var shopId: Int?
    private var totalProduct: Int = 0
    private var totalPrice: Int = 0
    private var arrayQuantity = [Int: Int]()
    private var arrayPrice = [Int: Int]()
    private var orderDetails: [OrderDetail] = []
    private var cartDetails: [ProductCartDetail] = []

    private lazy var presenter: MenuBrandPresenter = {
      let presenter = MenuBrandPresenter()
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
        if let topVC = UIViewController.topViewController() {
            presenter.onPostCart(createCart())
            let vc = ChooseVoucherViewController.makeMe()
            vc.setupData(with: createParams())
            topVC.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Private

private extension MenuBrandViewController {
    func setupUI() {
        hasNavigationBar = true
        title = "Menu"
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)

        tableView.register(DetailBrandMenuCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func updateUI() {
        if totalProduct < 1 {
            quantityOfProductLabel.text = "no product"
            continueButton.isEnabled = false
            continueButton.backgroundColor = R.color.grayA2A2A3()
            
        } else if totalProduct < 2 {
            quantityOfProductLabel.text = "\(totalProduct) product"
            continueButton.isEnabled = true
            continueButton.backgroundColor = R.color.blue4789FA()
        } else {
            quantityOfProductLabel.text = "\(totalProduct) products"
            continueButton.isEnabled = true
            continueButton.backgroundColor = R.color.blue4789FA()
        }
        totalPriceLabel.text = "\(formatToString(number: totalPrice))VNĐ"
    }
    
    func createParams() -> VoucherApplyModel {
        orderDetails.removeAll()
        
        var arrayProductId: [Int] = []
        arrayProductId.append(contentsOf: arrayQuantity.keys)
        
        var arrayAmount: [Int] = []
        arrayAmount.append(contentsOf: arrayQuantity.values)
        
        for i in 0...arrayQuantity.count - 1 {
            arrayAmount[i] > 0 ? orderDetails.append(OrderDetail(amount: arrayAmount[i], productId: arrayProductId[i])) : nil
        }
        
        let model = VoucherApplyModel(orderDetails: orderDetails, shopId: shopId.orEmpty)
        
        return model
    }

    func createCart() -> [String: Any] {
        cartDetails.removeAll()

        var arrayProductId: [Int] = []
        arrayProductId.append(contentsOf: arrayQuantity.keys)

        var arrayAmount: [Int] = []
        arrayAmount.append(contentsOf: arrayQuantity.values)


        for i in 0...arrayQuantity.count - 1 {
            arrayAmount[i] > 0 ? cartDetails.append(ProductCartDetail(amount: arrayAmount[i],
                                                                      productId: arrayProductId[i],
                                                                      image: "",
                                                                      name:  "",
                                                                      price: 0,
                                                                      shopId: shopId.orEmpty)) : nil
        }

        let model = CreateCartModel(cartDtos: cartDetails, shopId: shopId.orEmpty)
        return model.toDictionary()
    }
}

// MARK: - Public

extension MenuBrandViewController {
    func setupData(shopId: Int) {
        self.shopId = shopId
        presenter.onViewDidLoad(shopId: shopId)
    }
    
    func setupFromDetailProductToMenu(productId: Int, quantity: Int, price: Int) {
        arrayPrice.updateValue(price, forKey: productId)
        arrayQuantity.updateValue(quantity, forKey: productId)
        totalProduct += quantity
        totalPrice += quantity * price
    }
}

// MARK: - UITableViewDataSource

extension MenuBrandViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = presenter.products[indexPath.row]
        let cell = tableView.dequeue(DetailBrandMenuCell.self)
        cell.delegate = self
        cell.setupData(with: product, quantity: arrayQuantity[product.id] ?? 0)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MenuBrandViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = presenter.products[indexPath.row].id
        let vc = DetailProductViewController()
        vc.delegate = self
        vc.setupData(quantity: arrayQuantity[id] ?? 0, id: id, type: .menu, shopId: nil)
        pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - MenuBrandDelegate

extension MenuBrandViewController: MenuBrandDelegate {
    func totalProduct(number: Int, productId: Int, quantity: Int, price: Int) {
        arrayPrice.updateValue(price, forKey: productId)
        arrayQuantity.updateValue(quantity, forKey: productId)
        totalProduct += number
        totalPrice += number * price
        updateUI()
    }

    func totalDetailProduct(productId: Int, changeQuantity: Int, quantity: Int, price: Int) {
        arrayPrice.updateValue(price, forKey: productId)
        arrayQuantity.updateValue(quantity, forKey: productId)
        totalProduct += changeQuantity
        totalPrice += changeQuantity * price
        guard let shopId = shopId else { return }
        presenter.onViewDidLoad(shopId: shopId)
    }
}

// MARK: - MenuBrandViewInput

extension MenuBrandViewController: MenuBrandViewInput {
    func reloadTableViewData() {
        updateUI()
        tableView.reloadData()
    }
}
