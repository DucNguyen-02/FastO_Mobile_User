import UIKit
import FSPagerView

final class HomeBannerView: NibView {
    
    struct Constants {
        static let designItemSize = CGSize(width: 375, height: 210)
        static let designScreenWidth: CGFloat = 375
        static var itemSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = screenWidth / designScreenWidth
            let itemWidth = designItemSize.width * ratio
            let itemHeight = designItemSize.height * ratio
            return CGSize(width: itemWidth, height: itemHeight)
        }()
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var homePagerView: SafeFoodBannerView!
    
    // MARK: - Public Variable
    
    var banners: [VoucherModel] = [] {
        didSet {
            setupPagerView()
        }
    }
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        homePagerView.delegate = self
    }
}

// MARK: - Private

private extension HomeBannerView {
    func setupPagerView() {
        let bannerImageUrls = banners.map { $0.image }
        homePagerView.update(with: bannerImageUrls)
    }
}

// MARK: - DaPassBannerViewDelegate

extension HomeBannerView: SafeFoodBannerViewDelegate {
    func safeFoodBannerViewDidSelectItemAt(_ index: Int) {
        if let topVC = UIViewController.topViewController() {
            let vc = DetailVoucherViewController.makeMe()
            vc.voucherId = banners[index].id
            topVC.pushViewController(vc, animated: true)
        }
    }
}
