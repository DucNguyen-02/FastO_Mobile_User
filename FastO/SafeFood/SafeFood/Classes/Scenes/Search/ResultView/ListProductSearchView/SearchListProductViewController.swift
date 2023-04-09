import UIKit

final class SearchListProductViewController: BaseViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: BaseTableView!

    // MARK: - Public Variable

    var listProduct: [ProductModel] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func applyLocalization() {
        title = "List product"
    }
}

// MARK: - Private

private extension SearchListProductViewController {
    func setupUI() {
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchResultProductCell.self)
    }
}

// MARK: - UITableViewDataSource

extension SearchListProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProduct.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SearchResultProductCell.self, for: indexPath)
        cell.setupData(with: listProduct[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchListProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailProductViewController()
//        vc.isFromRecommendationMenuView = true
//        vc.brandId = listProduct[indexPath.row].brandId
//        vc.productId = listProduct[indexPath.row].id
        pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
