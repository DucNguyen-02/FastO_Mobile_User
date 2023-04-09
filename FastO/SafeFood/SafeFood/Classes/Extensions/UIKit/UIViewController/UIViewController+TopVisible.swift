import UIKit

extension UIViewController {
    static var topViewController: UIViewController? {
        return topViewController()
    }
    
    static func topViewController(of viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController ) -> UIViewController? {
        if let viewController = viewController as? UIPageViewController {
            return topViewController(of: viewController.viewControllers?.first)
        }
        
        if let viewController = viewController as? UINavigationController {
            return topViewController(of: viewController.visibleViewController)
        }
        
        if let viewController = viewController as? UITabBarController {
            if let viewController = viewController.selectedViewController {
                return topViewController(of: viewController)
            }
        }
        
        if let viewController = viewController?.presentedViewController {
            return topViewController(of: viewController)
        }
        
        return viewController
    }
}
