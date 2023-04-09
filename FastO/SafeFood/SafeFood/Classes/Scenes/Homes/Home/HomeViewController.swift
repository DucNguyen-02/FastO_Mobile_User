import UIKit

final class HomeViewController: BaseViewController {

    struct Constants {
        static let keyRecentKeyword = "RecentKeyword"
    }
    // MARK: - IBOutlet
    
    @IBOutlet private weak var recentBrandHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var hotVoucherHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topChartsHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var newsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var homeScrollView: UIScrollView!
    @IBOutlet private weak var recentBrandSectionContainerView: UIStackView!
    @IBOutlet private weak var homeSearchView: HomeSearchView!
    @IBOutlet private weak var homeRecentSearchView: HomeRecentKeywordView!
    @IBOutlet private weak var recentBrandSectionView: HomeRecentBrandView!
    @IBOutlet private weak var bannerSectionView: HomeBannerView!
    @IBOutlet private weak var hotVoucherSectionContainerView: UIStackView!
    @IBOutlet private weak var hotVoucherSectionView: HomeHotVoucherView!
    @IBOutlet private weak var topChartsSectionContainerView: UIStackView!
    @IBOutlet private weak var topChartsSectionView: HomeTopChartsView!
    @IBOutlet private weak var newsSectionContainerView: UIStackView!
    @IBOutlet private weak var newsSectionView: HomeNewsView!
    
    @IBOutlet private weak var wellcomeLabel: UILabel!
    @IBOutlet private weak var recentlyLabel: UILabel!
    @IBOutlet private weak var hotVoucherLabel: UILabel!
    @IBOutlet private weak var highestLabel: UILabel!
    @IBOutlet private weak var newsLabel: UILabel!
    @IBOutlet private weak var seeMoreRecentlyLabel: UILabel!
    @IBOutlet private weak var seeMoreHotVouchersLabel: UILabel!

    // MARK: - Private Variable

    private lazy var presenter: HomePresenter = {
        let presenter = HomePresenter()
        presenter.view = self
        return presenter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.getRecentBrand()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBAction
    
    @IBAction private func profileButtonTapped(_ sender: Any) {
        let vc = SettingViewController.makeMe()
        pushViewController(vc, animated: true)
    }
    
    @IBAction private func listRecentBrandButtonTapped(_ sender: Any) {
        let vc = ListRecentBrandViewController.makeMe()
        vc.recentBrands = presenter.recentBrand
        pushViewController(vc, animated: true)
    }
    
    @IBAction private func listHotVoucherButtonTapped(_ sender: Any) {
        let vc = ListHotVoucherViewController.makeMe()
        vc.hotVouchers = presenter.hotVouchers
        pushViewController(vc, animated: true)
    }
}

// MARK: - Public

extension HomeViewController {
    func scrollToTop() {
        homeScrollView.scrollToTop()
    }
}

// MARK: - Private

private extension HomeViewController {
    func setupUI() {
        setupHeightBaseOnWidthScreen()
    }
    
    func setupHeightBaseOnWidthScreen() {
        recentBrandHeightConstraint.constant = HomeRecentBrandView.Constants.itemSize.height
        bannerHeightConstraint.constant = HomeBannerView.Constants.itemSize.height
        hotVoucherHeightConstraint.constant = HomeHotVoucherView.Constants.itemSize.height
        topChartsHeightConstraint.constant = HomeTopChartsView.Constants.sectionHeight
        newsHeightConstraint.constant = HomeNewsView.Constants.sectionHeight
    }

    func setupUserDefaults() {
        homeRecentSearchView.isHidden = presenter.listRecentKeyword.isEmpty
        if let array = presenter.defaults.stringArray(forKey: Constants.keyRecentKeyword) {
            homeRecentSearchView.listKeyword = array
        }
    }
}

// MARK: - HomeRecentKeywordDelegate

extension HomeViewController: HomeRecentKeywordDelegate {
    func removeKeyword(keyword: String) {
        presenter.removeKeyword(keyword: keyword)
        setupUserDefaults()
    }

    func addKeyword(keyword: String) {
        presenter.addKeyword(keyword: keyword)
        setupUserDefaults()
    }
}

// MARK: - HomeNewsDelegate

extension HomeViewController: HomeNewsDelegate {
    func detailNews(id: Int) {
        if let topVC = UIViewController.topViewController() {
            let vc = DetailNewsViewController.makeMe()
            vc.setupData(id: id)
            topVC.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - HomeViewInput

extension HomeViewController: HomeViewInput {
    func reloadTableViewData() {
        recentBrandSectionContainerView.isHidden = presenter.recentBrand.isEmpty
        recentBrandSectionView.recentBrands = presenter.recentBrand
        
//        bannerSectionView.isHidden = presenter.banner.isEmpty
        bannerSectionView.banners = presenter.banner
        
        hotVoucherSectionContainerView.isHidden = presenter.hotVouchers.isEmpty
        hotVoucherSectionView.hotVouchers = presenter.hotVouchers
        
        topChartsSectionContainerView.isHidden = presenter.topVouchers.isEmpty && presenter.topBrands.isEmpty && presenter.topCommunity.isEmpty
        topChartsSectionView.topCommunity = presenter.topCommunity
        topChartsSectionView.topBrands = presenter.topBrands
        topChartsSectionView.topVouchers = presenter.topVouchers
        
        newsSectionContainerView.isHidden = presenter.news.isEmpty
        newsSectionView.listNews = presenter.news

        homeSearchView.homeRecentKeywordDelegate = self
        homeRecentSearchView.isHidden = presenter.listRecentKeyword.isEmpty
        if let array = presenter.defaults.stringArray(forKey: Constants.keyRecentKeyword) {
            presenter.listRecentKeyword = array
            homeRecentSearchView.listKeyword = presenter.listRecentKeyword
        }
        homeRecentSearchView.homeRecentKeywordDelegate = self

        newsSectionView.homeNewsDelegate = self
    }
}
