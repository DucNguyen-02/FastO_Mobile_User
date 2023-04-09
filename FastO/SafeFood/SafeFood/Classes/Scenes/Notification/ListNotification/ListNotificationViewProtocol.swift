import Foundation

protocol ListNotificationViewInput: AnyObject {
    func reloadTableViewData()
    func setInfiniteScrollingTableView(_ value: Bool)
    func stopInfiniteScrolling()
}

protocol ListNotificationViewOutput: AnyObject {
    func onViewDidLoad()
    func onTableViewLoadMore()
    func onSeenAllNotification()
    func onSeenNotification(seen: Int)
}
