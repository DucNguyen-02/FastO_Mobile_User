import UIKit

protocol CanPresentViewController {
    func presentInFullScreen(_ viewControllerToPresent: UIViewController, animated flag: Bool)
    func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Swift.Void)?
    )
    func presentOnTopVisible(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Swift.Void)?
    )
    
    func presentWithPushTransition(_ viewControllerToPresent: UIViewController)
    /// Present in navigation with the default presentation style (ios 13 .pageSheet, below 13 .fullscreen)
    func presentInNavigationController(
        rootViewController: UIViewController,
        animated flag: Bool,
        completion: (() -> Swift.Void)?
    )
    func presentInNavigationController(
        rootViewController: UIViewController,
        presentationStyle: UIModalPresentationStyle,
        animated flag: Bool,
        completion: (() -> Swift.Void)?
    )
}

extension UIViewController: CanPresentViewController {
    func presentInNavigationController(
        rootViewController: UIViewController,
        presentationStyle: UIModalPresentationStyle,
        animated flag: Bool,
        completion: (() -> Void)?
    ) {
        let navigationController = NavigationController(rootViewController: rootViewController)
        navigationController.modalPresentationStyle = presentationStyle
        present(navigationController, animated: flag, completion: completion)
    }
    
    func presentWithPushTransition(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        if view.window != nil {
            view.window?.layer.add(transition, forKey: kCATransition)
        } else {
            UIApplication.shared.delegate?.window??.layer.add(transition, forKey: kCATransition)
        }
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        self.present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    // To always present view controller in fullscreen in ios 13
    func presentInFullScreen(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool
    ) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen // default .automatic which will present overlap in ios 13
        present(viewControllerToPresent, animated: flag, completion: nil)
    }
    
    func presentOnTopVisible(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Swift.Void)?
    ) {
        if let topVisibleViewController = UIViewController.topViewController {
            topVisibleViewController.present(viewControllerToPresent, animated: flag, completion: completion)
        } else {
            present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
    
    func presentInNavigationController(
        rootViewController: UIViewController,
        animated flag: Bool,
        completion: (() -> Swift.Void)?
    ) {
        var presentationStyle: UIModalPresentationStyle
        if #available(iOS 13, *) {
            presentationStyle = .pageSheet
        } else {
            presentationStyle = .fullScreen
        }
        presentInNavigationController(rootViewController: rootViewController, presentationStyle: presentationStyle, animated: flag, completion: completion)
    }
}
