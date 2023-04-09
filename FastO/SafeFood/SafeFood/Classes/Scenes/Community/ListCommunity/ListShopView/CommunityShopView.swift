//
//  CommunityShopView.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/3/22.
//

import UIKit

final class CommunityShopView: NibView {

    struct Constants {
        static let all: String = "All"
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 4
        static let spaceBetween2Items: CGFloat = 12
        static let minItemWidth: CGFloat = 34
        static let minStringSize: CGSize = CGSize(width: 0, height: 20)
        static let designItemSize = CGSize(width: 120, height: 24)
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

    @IBOutlet private weak var collectionView: BaseCollectionView!

    // MARK: - Private Variable
    
    private var listCategory: [BrandModel] = []

    // MARK: - Public Variable

    weak var delegate: ListCommunityDelegate?
    var selectedShop: IndexPath? {
        didSet {
            if let indexPath = selectedShop {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func configureView() {
        super.configureView()
        setupUI()
    }
}

// MARK: - Private

private extension CommunityShopView {
    func setupUI() {
        collectionView.register(ListShopCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: Constants.verticalPadding, left: Constants.horizontalPadding, bottom: Constants.verticalPadding, right: Constants.horizontalPadding)
    }
}

// MARK: - Public

extension CommunityShopView {
    func setupData(with listBrand: [BrandModel]) {
        self.listCategory = listBrand
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension CommunityShopView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCategory.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ListShopCell.self, for: indexPath)
        if indexPath.row == 0 {
            cell.category = Constants.all
        } else {
            cell.category = listCategory[indexPath.row - 1].name
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommunityShopView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let communityId = indexPath.item == 0 ? nil : listCategory[indexPath.item - 1].id
        delegate?.chooseShop(id: communityId, indexPath: indexPath)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text: String = ""
        if indexPath.item == 0 {
            text = Constants.all
        } else {
            text = listCategory[indexPath.item - 1].name
        }
        let rect = text.boundingRect(with: Constants.minStringSize, options: NSStringDrawingOptions.usesFontLeading, attributes: [NSAttributedString.Key.font: R.font.lexendLight(size: 12)!], context: nil)

        return CGSize(width: rect.size.width + Constants.minItemWidth, height: Constants.itemSize.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetween2Items
    }
}
