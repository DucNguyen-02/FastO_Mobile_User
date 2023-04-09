import UIKit
import FBSDKLoginKit

enum AppCoordinatorState: Equatable {
    case firstLaunch
    case loggedIn
    case loggedOut(force: Bool)
}

protocol AppCoordinator: AnyObject {
    var state: AppCoordinatorState { get }
    
    func setup(with window: UIWindow)
    func launch()
}

final class AppCoordinatorImpl: AppCoordinator {
    
    private var rootControllerPresenter: RootControllerPresenter = RootControllerPresenterImpl()
    private var rootViewControllerProvider: RootViewControllerProvider = RootViewControllerProviderImpl()
    private let notificationCenterService: NotificationCenterService = NotificationCenter.default
    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    
    // MARK: - Public Variables
    
    private(set) var state: AppCoordinatorState = .firstLaunch
    
    // MARK: - Lifecycle
    
    deinit {
        notificationCenterService.removeObserver(self)
    }
    
    // MARK: - Public
    
    func setup(with window: UIWindow) {
        rootControllerPresenter.window = window
    }
    
    func launch() {
        setupObservers()
        let launchState = stateForLaunch()
        switchToState(launchState, animated: false)
    }
}

private extension AppCoordinatorImpl {
    func setupObservers() {
        notificationCenterService.addObserver(self, forName: AccountNotifications.authorizationCompleted) { [weak self] _ in
            self?.switchToState(.loggedIn, animated: true)
        }
        notificationCenterService.addObserver(self, forName: AccountNotifications.accountLoggedOut) { [unowned self] _ in
            LoginManager().logOut() // Logout Facebook
            self.defaultsStorage.cleanUpData()
            self.switchToState(.firstLaunch, animated: true)
        }
    }
    
    func stateForLaunch() -> AppCoordinatorState {
        // Kiem tra xem session có tồn tại không và không còn hạn session thì cho đăng nhập
        let accessToken = defaultsStorage.accessToken.orEmpty
        if accessToken.isNotEmpty {
            return .loggedIn
        }
        return .firstLaunch
    }
    
    func switchToState(_ updatedState: AppCoordinatorState, animated: Bool) {
        var animation: RootControllerPresenterAnimation = .none
        let rootViewController = rootViewControllerProvider.rootViewController(state: updatedState)
        
        if animated {
            switch updatedState {
            case .firstLaunch, .loggedOut:
                animation = .flipFromLeft
            case .loggedIn:
                animation = .flipFromRight
            }
        }
        
        state = updatedState
        rootControllerPresenter.switchToViewController(rootViewController, animation: animation, completion: nil)
    }
}
