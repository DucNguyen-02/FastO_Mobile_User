import Reachability

extension Reachability {
    var isNetworkAvailable: Bool {
        return (connection == .wifi) || (connection == .cellular)
    }
}
