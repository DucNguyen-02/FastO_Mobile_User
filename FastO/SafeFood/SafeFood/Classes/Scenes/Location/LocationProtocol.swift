import Foundation

protocol LocationViewInput: AnyObject, CanNavigateViewControllers {
    func updatePinOnMap(with brands: [BrandModel])
}

protocol LocationViewOutput: AnyObject {
    func onGetDataLocation(_ latitude: Double, _ longitude: Double)
}
