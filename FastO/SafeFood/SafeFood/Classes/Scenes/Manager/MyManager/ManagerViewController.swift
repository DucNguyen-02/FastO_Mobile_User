//
//  ManagerViewController.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/14/22.
//  
//

import UIKit

final class ManagerViewController: BaseViewController {
   
    struct Contants {
        static let success = "SUCCESS"
        static let fail = "FAIL"
        static let isUsed = "true"
        static let unUsed = "false"
        static let null = ""
        static let textColorBlack = R.color.black100() ?? .black
        static let textColorRed = R.color.redFF2929() ?? .red
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var collectionView: BaseCollectionView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleScreenLabel: UILabel!
    
    // MARK: - Private Variable
    

    private var datasource = MyManagerType.allCases
    private let paddingScreen: CGFloat = 16
    private var pageVC: UIPageViewController!
    private var listViewVC = [UIViewController]()
    private var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    private lazy var buyedVoucherViewController: ListVoucherViewController = {
        let vc = ListVoucherViewController.makeMe()
        vc.type = .buyed
        return vc
    }()
    private lazy var usedVoucherViewController: ListVoucherViewController = {
        let vc = ListVoucherViewController.makeMe()
        vc.type = .used
        return vc
    }()
    private lazy var errorVoucherViewController: ListVoucherViewController = {
        let vc = ListVoucherViewController.makeMe()
        vc.type = .error
        return vc
    }()
    private lazy var savedVoucherViewController: ListVoucherViewController = {
        let vc = ListVoucherViewController.makeMe()
        vc.type = .saved
        return vc
    }()
    
    private lazy var presenter: ManagerPresenter = {
        let presenter = ManagerPresenter()
        presenter.view = self
        return presenter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupPageViewController()
        setupUI()
    }
}

// MARK: - Private

private extension ManagerViewController {
    func setupUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SafeFoodTabTitleItem.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func setupViewControllers() {
        listViewVC = [
            buyedVoucherViewController,
            usedVoucherViewController,
            errorVoucherViewController,
            savedVoucherViewController
        ]
    }
    
    func setupPageViewController() {
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.setViewControllers([listViewVC.first!], direction: .forward, animated: true, completion: nil)
        containerView.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
    }
}

// MARK: - UIPageViewControllerDataSource

extension ManagerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = listViewVC.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard listViewVC.count > previousIndex else {
            return nil
        }
        return listViewVC[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = listViewVC.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard listViewVC.count > nextIndex else {
            return nil
        }
        return listViewVC[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension ManagerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        let newVCIndex = listViewVC.firstIndex(of: pageViewController.viewControllers!.first!)!
        let indexPath = IndexPath(row: newVCIndex, section: 0)
        selectedIndexPath = indexPath
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ManagerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SafeFoodTabTitleItem.self, for: indexPath)
        let type = datasource[indexPath.row]
        cell.title = type.title
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ManagerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let direction: UIPageViewController.NavigationDirection = selectedIndexPath.row
        < indexPath.row ? .forward : .reverse
        selectedIndexPath = indexPath
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageVC.setViewControllers([listViewVC[indexPath.row]], direction: direction, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ManagerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = collectionView.frame.height
        return CGSize(width: width / 4, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


// MARK: - ManagerViewInput

extension ManagerViewController: ManagerViewInput {
    func reloadTableViewData() {
        collectionView.reloadData()
    }
}
