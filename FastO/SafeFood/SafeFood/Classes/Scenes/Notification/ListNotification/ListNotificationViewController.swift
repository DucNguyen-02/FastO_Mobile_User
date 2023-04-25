import UIKit
import SVPullToRefresh

final class ListNotificationViewController: BaseViewController {
    
    struct Constant {
        static let heightRow: CGFloat = 80
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var backButton: BaseButton!
    @IBOutlet private weak var makeAllAsReadButton: BaseButton!
    @IBOutlet private weak var localizedTitleLabel: UILabel!
    @IBOutlet private weak var tableView: BaseTableView!
    
    // MARK: - Private Variable
    
    private var isTabbar: Bool = false
    private lazy var presenter: ListNotificationPresenter = {
        let presenter = ListNotificationPresenter()
        presenter.view = self
        return presenter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.onViewDidLoad()
    }
    
    override func applyLocalization() {
        localizedTitleLabel.text = "Notification"
        makeAllAsReadButton.setTitle("Make all as read", for: .normal)
    }
    
    // MARK: - IBAction
    
    @IBAction private func backButton(_ sender: Any) {
        popViewController(animated: true)
    }
    
    @IBAction private func makeAllAsReadButton(_ sender: Any) {
        presenter.onSeenAllNotification()
    }
}

// MARK: - Private

private extension ListNotificationViewController {
    func setupUI() {
        backButton.isHidden = isTabbar
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotificationCell.self)
        tableView.register(SafeFoodLoadingRow.self)
        tableView.addInfiniteScrolling { [weak self] in
            self?.presenter.onTableViewLoadMore()
        }
    }
}

// MARK: - Public

extension ListNotificationViewController {
    func setupData(isTabbar: Bool) {
        self.isTabbar = isTabbar
    }
}

// MARK: - UITableViewDataSource

extension ListNotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NotificationCell.self)
        cell.setupData(notification: presenter.notifications[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListNotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heightRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - ListNotificationViewInput

extension ListNotificationViewController: ListNotificationViewInput {
    func reloadTableViewData() {
        tableView.reloadData()
    }
    
    func setInfiniteScrollingTableView(_ value: Bool) {
        tableView.showsInfiniteScrolling = value
    }
    
    func stopInfiniteScrolling() {
        tableView.infiniteScrollingView.stopAnimating()
    }
}
