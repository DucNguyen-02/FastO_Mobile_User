import Foundation

protocol RatingViewInput: AnyObject {
    func dismissView()
}

protocol RatingViewOutput: AnyObject {
    func onViewDidLoad(review: [String: Any])
}
