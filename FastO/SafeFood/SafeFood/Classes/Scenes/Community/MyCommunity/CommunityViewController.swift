//
//  CommunityViewController.swift
//  SafeFood
//
//  Created by ADMIN on 22/11/2022.
//  
//

import UIKit

final class CommunityViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var collectionView: BaseCollectionView!
    @IBOutlet private weak var containerView: UIView!
    // MARK: - Private Variable

    private var dataSource = MyTabCommunity.allCases
    private let paddingScreen: CGFloat = 16
    private var pageVC: UIPageViewController!
    private var listViewVC = [UIViewController]()
    private var selectedIndexPath = IndexPath(item: 0, section: 0)

    private lazy var communityViewController: ListCommunityViewController = {
        let vc = ListCommunityViewController.makeMe()
        return vc
    }()
    private lazy var newsViewController: NewsViewController = {
        let vc = NewsViewController.makeMe()
        return vc
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - IBAction

    @IBAction private func notificationButtonTapped(_ sender: Any) {
        if let topVC = UIViewController.topViewController() {
            let vc = ListNotificationViewController()
            vc.setupData(isTabbar: false)
            topVC.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Private

private extension CommunityViewController {
    func setupUI() {
        setupCollectionView()
        setupViewControllers()
        setupPageViewController()
    }

    func setupCollectionView() {
        collectionView.register(SafeFoodTabTitleItem.self)
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }

    func setupViewControllers() {
        listViewVC = [communityViewController, newsViewController]
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

extension CommunityViewController: UIPageViewControllerDataSource {
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

extension CommunityViewController: UIPageViewControllerDelegate {
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

extension CommunityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SafeFoodTabTitleItem.self, for: indexPath)
        cell.title = dataSource[indexPath.item].title
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommunityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let direction: UIPageViewController.NavigationDirection = selectedIndexPath.row
            < indexPath.row ? .forward : .reverse
        selectedIndexPath = indexPath
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageVC.setViewControllers([listViewVC[indexPath.row]], direction: direction, animated: true, completion: nil)
        let cell = collectionView.cellForItem(at: indexPath) as! SafeFoodTabTitleItem
        cell.isSelected = true
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = collectionView.frame.height
        return CGSize(width: width / 2, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
