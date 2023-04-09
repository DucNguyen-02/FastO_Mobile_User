import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Public Variable
    
    var hasLargeTitle: Bool = false
    var hasNavigationBar: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        applyLocalization()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyLocalization),
            name: LocalizationNotification.didChange,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = hasLargeTitle
        navigationController?.setNavigationBarHidden(!hasNavigationBar, animated: animated)
    }
    
    deinit {
        removeNotificationsObserver()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @objc func applyLocalization() {}
}

private extension BaseViewController {
    func configUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        navigationController?.navigationBar.applyDaPassAppearance()
        navigationController?.makeNavBarTransparent()
        navigationItem.leftBarButtonItem = UIBarButtonItem.daPassBackButton(target: self, action: #selector(onBackButtonTap))
        navigationItem.leftBarButtonItem?.tintColor = R.color.black100()
        
    }
    
    @objc func onBackButtonTap() {
        popViewController(animated: true)
    }
}
