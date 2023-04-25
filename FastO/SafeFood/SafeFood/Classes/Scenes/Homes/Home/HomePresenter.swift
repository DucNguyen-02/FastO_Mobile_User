import Foundation
import SVProgressHUD

final class HomePresenter: HomeViewOutput {
    
    // MARK: - Private Variable
    
    private let group = DispatchGroup()
    
    // MARK: - Public Variable


    var brands: [BrandModel] = []
    var recentBrand: [BrandModel] = []
    var banner: [VoucherModel] = []
    var topBrands: [TopBrandModel] = []
    var topVouchers: [VoucherModel] = []
    var hotVouchers: [VoucherModel] = []
    var topCommunity: [HomeCommunityModel] = []
    var defaults = UserDefaults.standard
    var listRecentKeyword: [String] = []

    weak var view: HomeViewInput?
    
    func onViewDidLoad() {
        getInformation()
        getRecentBrand()
        getBanner()
        getHotVouchers()
        getTopVouchers()
        getTopBrands()
        group.notify(queue: .main) { [weak self] in
            self?.view?.reloadTableViewData()
        }
    }
}

// MARK: - Public

extension HomePresenter {
    func getRecentBrand() {
        group.enter()
        BrandService.shared.getRecentBrand { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(brands):
                self.recentBrand = brands

            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
// MARK: - Private

private extension HomePresenter {
    func getInformation() {
        UserService.shared.getUserProfile { result in
            switch result {
            case .success:
                break
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
    
    func getBanner() {
        group.enter()
        VoucherService.shared.getAllVoucher(type: .shop) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(banner):
                self.banner = banner

            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }

    func getHotVouchers() {
        group.enter()
        VoucherService.shared.getAllVoucher(type: .shop) { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(hotVouchers):
                self.hotVouchers = hotVouchers
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
    
    func getTopCommunity() {
        group.enter()
        CommunityService.shared.getTopCommunity { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(topCommunity):
                self.topCommunity = topCommunity

            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }

    func getTopVouchers() {
        VoucherService.shared.getAllVoucher(type: .shop) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(topVouchers):
                self.topVouchers = topVouchers

            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }

    func getTopBrands() {
        group.enter()
        BrandService.shared.getTopBrands { [weak self] result in
            defer { self?.group.leave() }
            guard let self = self else { return }
            switch result {
            case let .success(topBrands):
                self.topBrands = topBrands

            case let .failure(error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
}

// MARK: - Public

extension HomePresenter {
    func removeKeyword(keyword: String) {
        listRecentKeyword.removeAll { $0 == keyword }
        defaults.set(listRecentKeyword, forKey: HomeViewController.Constants.keyRecentKeyword)
    }

    func addKeyword(keyword: String) {
        listRecentKeyword.removeAll { $0 == keyword }
        listRecentKeyword.insert(keyword, at: 0)
        defaults.set(listRecentKeyword, forKey: HomeViewController.Constants.keyRecentKeyword)
    }
}
