import UIKit
import SVProgressHUD

protocol CanShowLoadingProgress {
    func startLoading()
    func finishLoading()
    func showError(_ error: String)
}

extension CanShowLoadingProgress where Self: UIViewController {
    func startLoading() {
        SVProgressHUD.show()
    }
    
    func finishLoading() {
        SVProgressHUD.dismiss()
    }
    
    func showError(_ error: String) {
        SVProgressHUD.showError(withStatus: error)
        SVProgressHUD.dismiss(withDelay: 1.5)
    }
}
