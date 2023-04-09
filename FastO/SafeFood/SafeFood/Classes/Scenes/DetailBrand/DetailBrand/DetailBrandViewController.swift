import UIKit

final class DetailBrandViewController: BaseViewController {
    
    struct Constants {
        static let maxVouchers: Int = 3
    }
    
    // MARK: - IBOutlet

    @IBOutlet private weak var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var summaryInfomationHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var recommendationMenuHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var voucherHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nearLocationHeightConstraint: NSLayoutConstraint!
  
    @IBOutlet private weak var bannerSectionView: DetailBrandBannerView!
    @IBOutlet private weak var summaryInfomationSectionView: DetailBrandSummaryInformationView!
    @IBOutlet private weak var recommendationMenuSectionView: DetailBrandRecommendationMenuView!
    @IBOutlet private weak var voucherSectionView: DetailBrandVoucherView!
    @IBOutlet private weak var ratingView: DetailBrandReviewView!
    @IBOutlet private weak var nearLocationSectionView: DetailBrandNearLocationView!
    
    @IBOutlet private weak var topLineRecommendationMenuView: UIView!
    @IBOutlet private weak var topLineVoucherView: UIView!
    @IBOutlet private weak var topLineNearLocationView: UIView!

    @IBOutlet private weak var topLineRating: UIView!
    @IBOutlet private weak var ratingStackView: UIStackView!
    @IBOutlet private weak var recommendationMenuSectionContainerView: UIStackView!
    @IBOutlet private weak var voucherSectionContainerView: UIStackView!
    @IBOutlet private weak var nearLocationSectionContainerView: UIStackView!
    @IBOutlet private weak var buyButton: BaseButton!
    @IBOutlet private weak var voucherButton: BaseButton!

    @IBOutlet private weak var locationsNearThisBrandLabel: UILabel!
    @IBOutlet private weak var voucherLabel: UILabel!
    @IBOutlet private weak var recommendationMenuLabel: UILabel!
    
    // MARK: - Private Variable

    private lazy var presenter: DetailBrandPresenter = {
        let presenter = DetailBrandPresenter()
        presenter.view = self
        return presenter
    }()
    
    // MARK: - Public Variable
    
    var brandId: Int?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        guard let brandId = brandId else { return }
        presenter.onViewDidLoad(with: brandId)
    }
    
    override func applyLocalization() {
        buyButton.setTitle(R.string.localizable.detail_brand_buy.localized(), for: .normal)
        voucherLabel.text = R.string.localizable.detail_brand_voucher.localized()
        recommendationMenuLabel.text = "Shop's Recommendation Menu"
        locationsNearThisBrandLabel.text = "The Location near with this shop"
    }
    
    // MARK: - IBAction

    @IBAction private func orderButtonTapped(_ sender: Any) {
        guard let detailBrand = presenter.detailBrand else { return }
        let vc = MenuBrandViewController.makeMe()
        vc.setupData(shopId: detailBrand.shopProfile.id)
        pushViewController(vc, animated: true)
    }
    
    @IBAction private func expanseVoucherButtonTapped(_ sender: Any) {
        if let detailBrand = presenter.detailBrand {
            let vc = DetailBrandExpanseVoucherViewController()
            vc.id = detailBrand.shopProfile.id
            pushViewController(vc, animated: true)
        }
    }

    @IBAction private func recommendationMenuButtonTapped(_ sender: Any) {
        if let detailBrand = presenter.detailBrand {
            let vc = MenuBrandViewController.makeMe()
            vc.setupData(shopId: detailBrand.shopProfile.id)
            pushViewController(vc, animated: true)
        }
    }
    
    @IBAction private func seeAllNearBrandButtonTapped(_ sender: Any) {
        let vc = DetailBrandNearLocationAllViewController()
        vc.brands = presenter.nearLocationBrands
        pushViewController(vc, animated: true)
    }
    
    @IBAction private func seeAllRatingButtonTapped(_ sender: Any) {
        if let topVC = UIViewController.topViewController() {
            let vc = ListReviewViewController()
            vc.setupData(reviews: presenter.reviews)
            topVC.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Private

private extension DetailBrandViewController {
    func setupUI() {
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)
        setupHeightBaseOnWidthScreen()
    }

    func setupHeightBaseOnWidthScreen() {
        bannerHeightConstraint.constant = DetailBrandBannerView.Constants.designItemSize.height
        summaryInfomationHeightConstraint.constant = DetailBrandSummaryInformationView.Constants.designItemSize.height
        recommendationMenuHeightConstraint.constant = DetailBrandRecommendationMenuView.Constants.itemSize.height
        nearLocationHeightConstraint.constant = DetailBrandNearLocationView.Constants.itemSize.height
    }
}

// MARK: - DetailBrandDelegate

extension DetailBrandViewController: DetailBrandDelegate {
    func likeBrand(isLike: Bool) {
        guard let brandId = brandId else { return }
        isLike ? presenter.onAddBrandFavourite(brandId: brandId) : presenter.onDeleteBrandFavourite(brandId: brandId)
    }
}

// MARK: - DetailBrandViewInput

extension DetailBrandViewController: DetailBrandViewInput {
    func updateUI() {
        guard let detailBrand = presenter.detailBrand else { return }
        title = detailBrand.shopProfile.name
        let count = detailBrand.listVoucher.count > Constants.maxVouchers ? Constants.maxVouchers : detailBrand.listVoucher.count
        voucherHeightConstraint.constant = CGFloat(count) * (DetailBrandVoucherView.Constants.cellHeight + DetailBrandVoucherView.Constants.bottomPadding)

        bannerSectionView.banners = detailBrand.shopProfile.images
        summaryInfomationSectionView.setupData(detailBrand.shopProfile)
        summaryInfomationSectionView.delegate = self
        recommendationMenuSectionContainerView.isHidden = detailBrand.listProduct.isEmpty
        topLineRecommendationMenuView.isHidden = detailBrand.listProduct.isEmpty
        recommendationMenuSectionView.menu = detailBrand.listProduct
        recommendationMenuSectionView.brandId = detailBrand.shopProfile.id

        voucherSectionContainerView.isHidden = detailBrand.listVoucher.isEmpty
        topLineVoucherView.isHidden = detailBrand.listVoucher.isEmpty
        voucherSectionView.vouchers = detailBrand.listVoucher

        nearLocationSectionContainerView.isHidden = presenter.nearLocationBrands.isEmpty
        topLineNearLocationView.isHidden = presenter.nearLocationBrands.isEmpty
        nearLocationSectionView.nearLocationBrands = presenter.nearLocationBrands
        
        ratingView.setupData(reviews: presenter.reviews)
        ratingView.isHidden = presenter.reviews.isEmpty
        ratingStackView.isHidden = presenter.reviews.isEmpty
        topLineRating.isHidden = presenter.reviews.isEmpty
    }
}
