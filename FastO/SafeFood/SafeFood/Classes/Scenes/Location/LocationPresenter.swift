import UIKit
import SVProgressHUD

final class LocationPresenter: LocationViewOutput {
    
    // MARK: - Public
    
    var listBrandLocation: [BrandModel] = []
    
    weak var view: LocationViewInput?
    
    func onGetDataLocation(_ latitude: Double, _ longitude: Double) {
        LocationService.shared.getListBrandLocation(latitude, longitude) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(listBrandLocation):
                self.listBrandLocation = listBrandLocation
                self.view?.updatePinOnMap(with: listBrandLocation)
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
