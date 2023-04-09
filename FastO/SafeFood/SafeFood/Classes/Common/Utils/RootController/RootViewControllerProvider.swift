import UIKit

protocol RootViewControllerProvider {
    func rootViewController(state: AppCoordinatorState) -> UIViewController
}

final class RootViewControllerProviderImpl: RootViewControllerProvider {
    // MARK: - Public
    
    func rootViewController(state: AppCoordinatorState) -> UIViewController {
        switch state {
        case .firstLaunch:
            return makeLandingScreen()
        case .loggedIn:
            return makeHomeScreen()
        case .loggedOut:
            return UIViewController()
        }
    }
    
    private func makeLandingScreen() -> NavigationController {
        let landingVC = SignInViewController.makeMe()
        let navigation = NavigationController(viewControllers: landingVC)
        navigation.setNavigationBarHidden(true, animated: false)
        return navigation
    }
    
    private func makeHomeScreen() -> NavigationController {
        let landingVC = TabBarViewController()
        let navigation = NavigationController(viewControllers: landingVC)
        navigation.setNavigationBarHidden(true, animated: false)
        return navigation
    }
}
