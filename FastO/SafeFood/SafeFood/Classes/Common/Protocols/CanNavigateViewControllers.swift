import UIKit

enum NavigateTransitionType: Equatable {
    case revealFromBottom
    case moveInFromBottom
    case fade
    case moveInFromRight
}

protocol CanNavigateViewControllers {
    func pushViewControllers(_ viewControllers: [UIViewController], with transitionType: NavigateTransitionType)
    func pushViewControllers(_ viewControllers: [UIViewController], animated: Bool)
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func pushViewController(_ viewController: UIViewController, with transitionType: NavigateTransitionType)
    func popViewController(animated: Bool)
    func popViewController(with transitionType: NavigateTransitionType)
    func popToRootViewController(animated: Bool)
    func popToRootViewController(with transitionType: NavigateTransitionType)
    func replacePreviousViewController(with viewController: UIViewController)
    func popBack(backSteps: Int, animated: Bool)
    @discardableResult
    func popBackTo(_ view: AnyClass) -> Bool
    @discardableResult
    func popBackTo(_ view: AnyClass, transitionType: NavigateTransitionType) -> Bool
    @discardableResult
    func hasViewController(_ view: AnyClass) -> UIViewController?
}

extension UIViewController: CanNavigateViewControllers {
}

extension CanNavigateViewControllers where Self: UIViewController {
    func pushViewControllers(_ viewControllers: [UIViewController], with transitionType: NavigateTransitionType) {
        guard let stack = navigationStackViewControllers(from: viewControllers) else {
            return
        }
        let transition = getTransition(with: transitionType)
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.setViewControllers(stack, animated: false)
    }
    
    func pushViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        guard let stack = navigationStackViewControllers(from: viewControllers) else {
            return
        }
        navigationController?.setViewControllers(stack, animated: animated)
    }
    
    private func navigationStackViewControllers(from viewControllers: [UIViewController]) -> [UIViewController]? {
        guard var stack = navigationController?.viewControllers else {
            return nil
        }
        stack.append(contentsOf: viewControllers)
        return stack
    }
    
    func popViewController(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popViewController(with transitionType: NavigateTransitionType) {
        let transition = getTransition(with: transitionType)
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: false)
    }
    
    func pushViewController(_ viewController: UIViewController, with transitionType: NavigateTransitionType) {
        let transition = getTransition(with: transitionType)
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func popToRootViewController(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func popToRootViewController(with transitionType: NavigateTransitionType) {
        let transition = getTransition(with: transitionType)
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popToRootViewController(animated: false)
    }
    
    func replacePreviousViewController(with viewController: UIViewController) {
        guard let navigationController = navigationController, navigationController.viewControllers.isNotEmpty,
              let index = navigationController.viewControllers.lastIndex(of: self) else {
            return
        }
        
        var updatedStack: [UIViewController] = []
        updatedStack.append(contentsOf: navigationController.viewControllers)
        
        if index > 0 {
            updatedStack.insert(viewController, at: index - 1)
            updatedStack.remove(at: index)
        } else {
            updatedStack.insert(viewController, at: 0)
        }
        
        navigationController.setViewControllers(updatedStack, animated: false)
    }
    
    func popBack(backSteps: Int, animated: Bool) {
        let steps = backSteps + 1
        guard let navigationController = navigationController else {
            return
        }
        
        let viewControllers = navigationController.viewControllers
        let updatedIndex = viewControllers.count - steps
        if updatedIndex >= 0 {
            let viewController = viewControllers[updatedIndex]
            navigationController.popToViewController(viewController, animated: animated)
        } else {
            popToRootViewController(animated: animated)
        }
    }
    
    @discardableResult
    func popBackTo(_ view: AnyClass) -> Bool {
        guard
            let navigationController = navigationController,
            let viewController = navigationController.viewControllers.reversed().first(where: { $0.isKind(of: view) })
        else { return false }
        
        navigationController.popToViewController(viewController, animated: true)
        return true
    }
    
    @discardableResult
    func popBackTo(_ view: AnyClass, transitionType: NavigateTransitionType) -> Bool {
        guard
            let navigationController = navigationController,
            let viewController = navigationController.viewControllers.reversed().first(where: { $0.isKind(of: view) })
        else { return false }
        
        let transition = getTransition(with: transitionType)
        navigationController.view.layer.add(transition, forKey: nil)
        navigationController.popToViewController(viewController, animated: false)
        return true
    }
    
    @discardableResult
    func hasViewController(_ view: AnyClass) -> UIViewController? {
        guard
            let navigationController = navigationController,
            let viewController = navigationController.viewControllers.reversed().first(where: { $0.isKind(of: view) })
        else { return nil }
        
        return viewController
    }
}

// MARK: - Private

private extension CanNavigateViewControllers {
    func getTransition(with type: NavigateTransitionType) -> CATransition {
        let transition = CATransition()
        switch type {
        case .revealFromBottom:
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromBottom
        case .moveInFromBottom:
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
        case .fade:
            let transition: CATransition = CATransition()
            transition.duration = 0.3
            transition.type = CATransitionType.fade
        case .moveInFromRight:
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
        }
        return transition
    }
}
