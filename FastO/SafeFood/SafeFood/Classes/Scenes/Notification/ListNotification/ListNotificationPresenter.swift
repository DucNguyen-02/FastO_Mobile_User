import Foundation

final class ListNotificationPresenter {
    
    // MARK: - Private Variable
    
    private var page: Int = 1
    private var arrayIdUnRead = [Int]()
    
    // MARK: - Public Variable
    
    weak var view: ListNotificationViewInput?
    var notifications: [NotificationModel] = []
}

// MARK: - NotificationViewOutput

extension ListNotificationPresenter: ListNotificationViewOutput {
    func onViewDidLoad() {
        getNotifications()
    }
    
    func onTableViewLoadMore() {
        NotificationService.shared.getListNotification(page: page) { [weak self] result in
            self?.view?.stopInfiniteScrolling()
            guard let self = self else { return }
            switch result {
            case let .success(notifications):
                if !notifications.isEmpty {
                    self.notifications.append(contentsOf: notifications)
                    self.page += 1
                    self.view?.reloadTableViewData()
                } else {
                    self.view?.setInfiniteScrollingTableView(false)
                }
                
            case .failure:
                self.view?.setInfiniteScrollingTableView(false)
            }
        }
    }
    
    func onSeenAllNotification() {
        arrayIdUnRead = notifications.filter { !$0.seenFlag } .map { $0.notificationId }
        putSeenAllNotification(seen: arrayIdUnRead)
    }
    
    func onSeenNotification(seen: Int) {
        putSeenNotification(seen: seen)
    }
}

// MARK: - Private

private extension ListNotificationPresenter {
    func getNotifications() {
        page = 1
        NotificationService.shared.getListNotification(page: page) { [weak self] result in
            self?.view?.stopInfiniteScrolling()
            guard let self = self else { return }
            switch result {
            case let .success(notifications):
                self.notifications = notifications
                self.page += 1
                self.view?.reloadTableViewData()
                
            case let .failure(error):
                self.view?.setInfiniteScrollingTableView(false)
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func putSeenAllNotification(seen: [Int]) {
        NotificationService.shared.putSeenNotification(seen: seen) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.notifications.removeAll()
                self.getNotifications()
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func putSeenNotification(seen: Int) {
        NotificationService.shared.putSeenNotification(seen: [seen]) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
}
