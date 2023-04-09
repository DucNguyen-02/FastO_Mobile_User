import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getTabBar()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applyLocalization),
                                               name: LocalizationNotification.didChange,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func applyLocalization() {
        getTabBar()
    }
     
     deinit {
         NotificationCenter.default.removeObserver(self)
     }
}

// MARK: - Helper

extension TabBarViewController {
    private func setUpUI() {
        self.delegate = self
        tabBar.tintColor = R.color.black100() ?? .black
        tabBar.barTintColor = R.color.white100() ?? .white
        tabBar.backgroundColor = R.color.white100() ?? .white
        tabBar.clipsToBounds = false
        tabBar.unselectedItemTintColor = R.color.black100() ?? .black
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        tabBar.addRoundShadow(radius: 0,
                              size: CGSize(width: 0, height: 20),
                              shadowRadius: 20,
                              color: R.color.black100() ?? .black,
                              opacity: 0.3)
        
        let tabbarAppearance = UITabBarItem.appearance()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: R.font.lexendLight(size: 11)!
        ]
        tabbarAppearance.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func getTabBar() {
        let viewControllers: [UIViewController] = TabBarType.allCases.map {
            let item = UITabBarItem(title: "", image: $0.icon, selectedImage: $0.iconSelected)
            switch $0 {
            case .home:
                let viewController = HomeViewController.makeMe()
                viewController.tabBarItem = UITabBarItem(title: "Home", image: $0.icon, selectedImage: $0.iconSelected)
                return viewController
                
            case .manager:
                let viewController = ManagerViewController.makeMe()
                viewController.tabBarItem = item
                return viewController
                
            case .community:
                let viewController = CommunityViewController.makeMe()
                viewController.tabBarItem = item
                return viewController
                
            case .location:
                let viewController = LocationViewController.makeMe()
                viewController.tabBarItem = item
                return viewController
                
            case .notification:
                let viewController = ListNotificationViewController()
                viewController.setupData(isTabbar: true)
                viewController.tabBarItem = item
                return viewController
            }
        }
        self.viewControllers = viewControllers
    }
    
    func setupShowTitleTabbar(tabBarController: UITabBarController) {
        let index = tabBarController.selectedIndex
        guard let tabBarItems = tabBarController.tabBar.items else { return }
        let tabBar = TabBarType(rawValue: index)
        switch index {
        case 0, 1, 2, 3, 4:
            tabBarItems.enumerated().forEach {
                if $0.offset == tabBar?.rawValue {
                    $0.element.title = tabBar?.title
                } else {
                    $0.element.title = ""
                }
            }
        default:
            break
        }
    }
    
//    func selectedHomeItem(viewController: UIViewController) {
//        if let vc = viewController as? HomeViewController {
//            vc.scrollToTop()
//        }
//    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        setupShowTitleTabbar(tabBarController: tabBarController)
    }
}
