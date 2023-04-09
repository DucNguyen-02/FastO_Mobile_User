import UIKit
import STPopup

extension UIViewController {
    static func makeMe() -> Self {
        let className = String(describing: self.classForCoder())
        let storyboard = UIStoryboard(name: className, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: className) as! Self
        return controller
    }
    
    var isRootViewController: Bool {
        return navigationController?.viewControllers.first == self
    }
    
    /// Check ViewController Push or Present
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
    var statusBarHeight: CGFloat {
        var statusBar: CGFloat = 0.0
        if #available(iOS 13, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBar = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBar = UIApplication.shared.statusBarFrame.height
        }
        return statusBar
    }
    
    // Height of status bar + navigation bar (if navigation bar exist)
    var topBarHeight: CGFloat {
        let navigationHeight = navigationController?.navigationBar.frame.height ?? 0.0
        return navigationHeight + statusBarHeight
    }
    
    var tabBarHeight: CGFloat {
        if tabBarController?.tabBar.isHidden ?? true { return 0 }
        return tabBarController?.tabBar.frame.size.height ?? 0
    }
    
    class func initWithNibTemplate<T>() -> T {
        let nibName = String(describing: self)
        let viewcontroller = self.init(nibName: nibName, bundle: Bundle.main)
        return viewcontroller as! T
    }
    
    class func initWithNibTemplate<T>(nibName: String) -> T {
        let viewcontroller = self.init(nibName: nibName, bundle: Bundle.main)
        return viewcontroller as! T
    }
}

// MARK: - Notification

extension UIViewController {
    /// - Parameters:
    ///   - name: notification name.
    ///   - selector: selector to run with notified.
    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }

    /// - Parameter name: notification name.
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }

    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - FormatToString

extension UIViewController {
    func formatToString(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true

        let number = NSNumber(value: number)
        let numberString = numberFormatter.string(from: number).orEmpty
        return numberString
    }

    func setupSTPopup(vc: UIViewController) -> STPopupController {
        let popupController = STPopupController(rootViewController: vc)
        popupController.navigationBar.isHidden = true
        popupController.transitionStyle = .slideVertical
        popupController.containerView.layer.cornerRadius = 0
        popupController.containerView.backgroundColor = .clear
        popupController.safeAreaInsets.bottom = 0
        popupController.style = .bottomSheet
        popupController.backgroundView?.backgroundColor = R.color.black060606() ?? .black
        popupController.backgroundView?.alpha = 0.7
        popupController.present(in: self)

        return popupController
    }
}
