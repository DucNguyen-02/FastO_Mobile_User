import UIKit

final class HomeTopChartCommunityViewController: BaseViewController {
    
    struct Constants {
        static let numberItems: Int = 4
        static let cellHeight: CGFloat = 106
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: BaseTableView!
    
    // MARK: - Public Variable

    var topCommunity: [HomeCommunityModel] = [] {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - LifeCyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private

private extension HomeTopChartCommunityViewController {
    func setupUI() {
        tableView.register(HomeTopChartCommunityCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension HomeTopChartCommunityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topCommunity.count > Constants.numberItems ? Constants.numberItems : topCommunity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HomeTopChartCommunityCell.self)
        let index = indexPath.row
        cell.setupData(index: index, community: topCommunity[index])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeTopChartCommunityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController() {
            let vc = DetailCommunityViewController.makeMe()
            vc.setupData(id: topCommunity[indexPath.row].reviewId)
            topVC.pushViewController(vc, animated: true)
        }
    }
}
