import Foundation

final class DetailBrandPresenter {

    // MARK: - Private Variable

    private let group = DispatchGroup()

    // MARK: - Public Variable
    
    var detailBrand: DetailBrandModel?
    var nearLocationBrands: [NearBrandModel] = []
    var reviews: [ReviewModel] = []
    weak var view: DetailBrandViewInput?
}

// MARK: - DetailBrandViewOutput

extension DetailBrandPresenter: DetailBrandViewOutput {
    func onViewDidLoad(with brandId: Int) {
        getDetailBrand(brandId)
        getDetailBrandNearLocation(brandId)
        getRating(shopId: brandId)

        group.notify(queue: .main) { [weak self] in
            self?.view?.updateUI()
        }
    }
    
    func onAddBrandFavourite(brandId: Int) {
        addBrandFavourite(id: brandId)
    }
    
    func onDeleteBrandFavourite(brandId: Int) {
        deteleBrandFavourite(id: brandId)
    }
}

// MARK: - Private

private extension DetailBrandPresenter {
    func getDetailBrand(_ brandId: Int) {
        group.enter()
        BrandService.shared.getDetailShop(id: brandId) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(detailBrand):
                self.detailBrand = detailBrand

            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }

    func getDetailBrandNearLocation(_ brandId: Int) {
        group.enter()
        BrandService.shared.getListNearBrand(id: brandId) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(nearLocationBrands):
                self.nearLocationBrands = nearLocationBrands

            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func getRating(shopId: Int) {
        group.enter()
        RatingService.shared.getRatings(id: shopId) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(reviews):
                self.reviews = reviews

            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func addBrandFavourite(id: Int) {
        BrandService.shared.putAddBrandFavourite(id: id) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
    
    func deteleBrandFavourite(id: Int) {
        BrandService.shared.putDeleteBrandFavourite(id: id) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
