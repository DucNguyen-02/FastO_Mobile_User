import Foundation

enum MyTabCommunity: Int, CaseIterable {
    case community = 0
    case news

    var title: String {
        switch self {
        case .community:
            return "Community"
        case .news:
            return "News"
        }
    }
}
