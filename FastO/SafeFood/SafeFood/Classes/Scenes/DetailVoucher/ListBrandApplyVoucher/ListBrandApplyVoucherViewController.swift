//
//  ListBrandApplyVoucherViewController.swift
//  SafeFood
//
//  Created by Zipris on 28/11/2022.
//  
//

import UIKit

final class ListBrandApplyVoucherViewController: BaseViewController {
    
    struct Constants {
        static let topPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 16
        static let spaceBetween2Items: CGFloat = 16
        static var itemSize: CGSize = {
            let numberItemInRow: CGFloat = 2
            let screenWidth = UIScreen.main.bounds.width
            let totalOffset = horizontalPadding * 2 + spaceBetween2Items * (numberItemInRow - 1)
            var itemWidth = (screenWidth - totalOffset) / numberItemInRow
            itemWidth.round(.down)
            let itemHeight: CGFloat = 200
            return CGSize(width: itemWidth, height: itemHeight)
        }()
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var collectionView: BaseCollectionView!
    
    // MARK: - Private Variable
    
    private lazy var presenter: ListBrandApplyVoucherPresenter = {
      let presenter = ListBrandApplyVoucherPresenter()
      presenter.view = self
      return presenter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.onViewDidLoad()
    }
    
    override func applyLocalization() {
        
    }
}

// MARK: - Private

private extension ListBrandApplyVoucherViewController {
    func setupUI() {
        hasNavigationBar = true
        title = "List Brand"
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = Constants.itemSize
        flowLayout.minimumLineSpacing = Constants.spaceBetween2Items
        flowLayout.minimumInteritemSpacing = Constants.spaceBetween2Items
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(SafeFoodBrandItem.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 12, left: Constants.horizontalPadding, bottom: 12, right: Constants.horizontalPadding)
    }
    
    func setupData(for cell: SafeFoodBrandItem, recentBrands: BrandModel) {
        cell.numberCount = nil
        cell.title = recentBrands.name
        cell.subtitle = recentBrands.description
        cell.imageUrl = recentBrands.logo
        cell.ratingStar = CGFloat(recentBrands.ratings)
        cell.countStar = recentBrands.ratingNumber
        cell.quantityOfVoted = recentBrands.ratings
    }
}

// MARK: - UICollectionViewDataSource

extension ListBrandApplyVoucherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.brands.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SafeFoodBrandItem.self, for: indexPath)
        setupData(for: cell, recentBrands: presenter.brands[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ListBrandApplyVoucherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController {
            let id = presenter.brands[indexPath.row].id
            let vc = DetailBrandViewController.makeMe()
            vc.brandId = id
            topVC.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ListBrandApplyVoucherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetween2Items
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetween2Items
    }
}

// MARK: - ListBrandApplyVoucherViewInput

extension ListBrandApplyVoucherViewController: ListBrandApplyVoucherViewInput {
    func reloadCollectionViewData() {
        collectionView.reloadData()
    }
}
