import UIKit
import SafariServices

protocol CanPresentSafariViewController {
    func presentInSafariController(url: URL)
}

extension CanPresentSafariViewController where Self: CanPresentViewController {
    func presentInSafariController(url: URL) {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = false
        let vc = SFSafariViewController(url: url, configuration: configuration)
        presentOnTopVisible(vc, animated: true, completion: nil)
    }
}
