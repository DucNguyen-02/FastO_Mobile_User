import UIKit

enum HomeTopChartsType: Int, CaseIterable {
    case voucher = 0
    case brand
    case community
    
    var title: String {
        switch self {
        case .voucher:
            return "Voucher"
        case .brand:
            return "Brand"
        case .community:
            return "Community"
        }
    }
}

final class HomeTopChartsView: NibView {
    
    struct Constants {
        static let horizontalPadding: CGFloat = 16
        static let tabTitleHeight: CGFloat = 24
        static let spaceBetweenTabAndViewController: CGFloat = 8
        static let sectionHeight: CGFloat = {
            let numberCell = CGFloat(HomeTopChartVoucherViewController.Constants.numberItems)
            let cellHeight = HomeTopChartVoucherViewController.Constants.cellHeight
            let bottomCellPadding = HomeTopChartVoucherViewController.Constants.bottomPadding
            let viewControllerHeight = (cellHeight + bottomCellPadding) * numberCell
            
            return tabTitleHeight + spaceBetweenTabAndViewController + viewControllerHeight
        }()
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var collectionView: BaseCollectionView!
    
    // MARK: - Public Variable
    
    var topVouchers: [VoucherModel] = [] {
        didSet {
            topChartVoucherViewController.topVouchers = topVouchers
        }
    }
    
    var topCommunity: [HomeCommunityModel] = [] {
        didSet {
            topChartCommunityViewController.topCommunity = topCommunity
        }
    }
    
    var topBrands: [TopBrandModel] = [] {
        didSet {
            topChartBrandViewController.topBrands = topBrands
        }
    }
    
    // MARK: - Private Variable
    
    private var pageVC: UIPageViewController!
    private var listViewControllers = [UIViewController]()
    private var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    private lazy var topChartVoucherViewController: HomeTopChartVoucherViewController = {
        let vc = HomeTopChartVoucherViewController.makeMe()
        return vc
    }()
    private lazy var topChartBrandViewController: HomeTopChartBrandViewController = {
        let vc = HomeTopChartBrandViewController.makeMe()
        return vc
    }()
    private lazy var topChartCommunityViewController: HomeTopChartCommunityViewController = {
        let vc = HomeTopChartCommunityViewController.makeMe()
        return vc
    }()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        setupViewControllers()
        setupPageViewController()
        setupUI()
    }
}

// MARK: - Private

private extension HomeTopChartsView {
    func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SafeFoodTabTitleItem.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: 0, right: Constants.horizontalPadding)
        
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func setupViewControllers() {
        listViewControllers = [
            topChartVoucherViewController,
            topChartBrandViewController,
            topChartCommunityViewController
        ]
    }
    
    func setupPageViewController() {
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.setViewControllers([listViewControllers.first!], direction: .forward, animated: true, completion: nil)
        containerView.addSubview(pageVC.view)
        pageVC.view.pinViewToEdgesOfSuperview()
    }
}

// MARK: - UIPageViewControllerDataSource

extension HomeTopChartsView: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = listViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard listViewControllers.count > previousIndex else {
            return nil
        }
        return listViewControllers[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = listViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard listViewControllers.count > nextIndex else {
            return nil
        }
        return listViewControllers[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension HomeTopChartsView: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        let newVCIndex = listViewControllers.firstIndex(of: pageViewController.viewControllers!.first!)!
        let indexPath = IndexPath(row: newVCIndex, section: 0)
        selectedIndexPath = indexPath
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeTopChartsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeTopChartsType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SafeFoodTabTitleItem.self, for: indexPath)
        if let title = HomeTopChartsType(rawValue: indexPath.row)?.title {
            cell.title = title
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HomeTopChartsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let direction: UIPageViewController.NavigationDirection = selectedIndexPath.row
        < indexPath.row ? .forward : .reverse
        selectedIndexPath = indexPath
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageVC.setViewControllers([listViewControllers[indexPath.row]], direction: direction, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeTopChartsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - Constants.horizontalPadding * 2
        let height = collectionView.frame.height
        let numberTabs = CGFloat(HomeTopChartsType.allCases.count)
        
        return CGSize(width: width / numberTabs, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
