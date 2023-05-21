import UIKit

enum TabBarType: Int, CaseIterable {
    case home = 0
    case manager
//    case community
    case location
//    case notification
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .manager:
            return "Manager"
//        case .community:
//            return "Community"
        case .location:
            return "Location"
//        case .notification:
//            return "Notification"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .home:
            return R.image.tabbar_home()
            
        case .manager:
            return R.image.tabbar_voucher()
            
//        case .community:
//            return R.image.tabbar_community()
            
        case .location:
            return R.image.tabbar_location()
            
//        case .notification:
//            return R.image.tabbar_notification()
        }
    }
    
    var iconSelected: UIImage? {
        switch self {
        case .home:
            return R.image.tabbar_home()

        case .manager:
            return R.image.tabbar_voucher()

//        case .community:
//            return R.image.tabbar_community()

        case .location:
            return R.image.tabbar_location()
            
//        case .notification:
//            return R.image.tabbar_notification()
        }
    }
}
