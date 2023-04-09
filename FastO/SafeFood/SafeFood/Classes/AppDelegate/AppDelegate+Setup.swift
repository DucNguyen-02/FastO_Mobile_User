import IQKeyboardManagerSwift
import FBSDKCoreKit
import Toaster
import SVProgressHUD

extension AppDelegate {
    func setupAppearance() {
        setupIQKeyboard()
        setupToastView()
        setupSVProgressHUD()
        setUpNavigationBar()
    }
}

private extension AppDelegate {
    func setupIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Xong"
    }
    
    func setupToastView() {
        ToastView.appearance().textInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        ToastView.appearance().bottomOffsetPortrait = 40
        ToastView.appearance().backgroundColor = UIColor.black
        ToastView.appearance().textColor = UIColor.white
        ToastView.appearance().shadowColor = UIColor.black
        ToastView.appearance().shadowOffset = CGSize(width: 0, height: 2)
        ToastView.appearance().shadowOpacity = 0.3
        ToastView.appearance().shadowRadius = 2
        ToastView.appearance().useSafeAreaForBottomOffset = true
        ToastView.appearance().font = R.font.lexendMedium(size: 12)!
    }
    
    func setupSVProgressHUD() {
//        SVProgressHUD.setForegroundColor(R.color.blue4789FA() ?? .blue)  // Ring Color
//        SVProgressHUD.setBackgroundColor(.clear) // HUD Color
        SVProgressHUD.setRingThickness(6)
        SVProgressHUD.setDefaultMaskType(.black) // behind background Color
        SVProgressHUD.setFont(R.font.lexendRegular(size: 14)!)
    }
    
    func setUpNavigationBar() {
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundColor = R.color.white100() ?? .white
            navigationBarAppearance.shadowImage = UIImage()
            navigationBarAppearance.shadowColor = nil
            navigationBarAppearance.titleTextAttributes = [
                .foregroundColor: R.color.black100() ?? .black,
                .font: R.font.lexendMedium(size: 17)!
            ]
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        } else {
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
        }
        UINavigationBar.appearance().tintColor = R.color.black100() ?? .black
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: R.color.black100() ?? .black,
            .font: R.font.lexendMedium(size: 17)!
        ]
    }
}

// MARK: - Login Facebook

extension AppDelegate {
    func setupLoginFacebook(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        ApplicationDelegate.shared.application(application,
                                               didFinishLaunchingWithOptions: launchOptions)
    }

    func loginFacebook(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}

// MARK: - Login Google

extension AppDelegate {
    func loginGoogle(open url: URL) -> Bool {
        if let authorizationFlow = googleAppAuthSession, authorizationFlow.resumeExternalUserAgentFlow(with: url) {
            googleAppAuthSession = nil
            return true
        }
        return false
    }
}
