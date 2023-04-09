import UIKit
import AppAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Private Variable

    private let notificationCenter: NotificationCenterService = NotificationCenter.default

    // MARK: - Public Variable

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var googleAppAuthSession: OIDExternalUserAgentSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        setupAppearance()
        setupAppCoordinator()
        setupLoginFacebook(application,
                           didFinishLaunchingWithOptions: launchOptions)

        window?.makeKeyAndVisible()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        loginFacebook(app, open: url, options: options)
        if loginGoogle(open: url) { return true }

        receivePaymentResult(app, open: url, options: options)
        return false
    }
}

// MARK: - Private

private extension AppDelegate {
    func setupAppCoordinator() {
        appCoordinator = AppCoordinatorImpl()
        appCoordinator?.setup(with: window!)
        appCoordinator?.launch()
    }
    
    func receivePaymentResult(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) {
        if url.absoluteString.contains(APIConstant.vnpayRedirectUrl) {
            let queryParams = url.queryParameters ?? [:]
            let requestModel = VNPaymentResultRequestModel(query: queryParams)
            notificationCenter.post(name: PaymentNotification.paymentVNPayCompleted,
                                    object: requestModel)
        }
    }
}
