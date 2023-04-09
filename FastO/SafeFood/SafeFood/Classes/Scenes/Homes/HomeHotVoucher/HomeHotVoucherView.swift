import  UIKit

enum HomeHotVoucherSection: Int, CaseIterable {
    case banner = 0
    case hot
}

final class HomeHotVoucherView: NibView {
    
    struct Constants {
        static let horizontalPadding: CGFloat = 16
        static let spaceBetween2Items: CGFloat = 12
        static let designItemSize = CGSize(width: 120, height: 180)
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
    
    private let type: VoucherType = .percent
    
    // MARK: - Public Variable
    
    var hotVouchers: [VoucherModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
        
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        setUpCollectionView()
    }
}

// MARK: - Private

private extension HomeHotVoucherView {
    func setUpCollectionView() {
        collectionView.register(HomeHotVoucherCell.self)
        collectionView.register(SafeFoodVoucherItem.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupData(for cell: SafeFoodVoucherItem, hotVoucher: VoucherModel) {
        cell.title = hotVoucher.name
        cell.subtitle = hotVoucher.description
        cell.imageUrl = hotVoucher.image
        cell.discountPercent = hotVoucher.valueDiscount
        cell.discountType = hotVoucher.voucherType == type ? "%" : "VNĐ"
        cell.price = nil
        cell.isShowUpcomingView = hotVoucher.status != .inactive
    }
}

// MARK: - UICollectionViewDataSource

extension HomeHotVoucherView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeHotVoucherSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = HomeHotVoucherSection(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .banner:
            return 1 
        case .hot:
            return hotVouchers.count - 1
        }
}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = HomeHotVoucherSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch sectionType {
        case .banner:
            let cell = collectionView.dequeue(HomeHotVoucherCell.self, for: indexPath)
            guard let hotVoucher = hotVouchers[safe: 0] else { return cell}
            cell.setupdata(hotVoucher: hotVoucher)
            return cell
            
        case .hot:
            let cell = collectionView.dequeue(SafeFoodVoucherItem.self, for: indexPath)
            setupData(for: cell, hotVoucher: hotVouchers[indexPath.item + 1])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeHotVoucherView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = HomeHotVoucherSection(rawValue: indexPath.section) else { return  }
        switch sectionType {
        case .banner:
            if let topVC = UIViewController.topViewController {
                let vc = DetailVoucherViewController.makeMe()
                guard let hotVoucher = hotVouchers[safe: 0] else { return }
                vc.voucherId = hotVoucher.id
                topVC.pushViewController(vc, animated: true)
            }
        case .hot:
            if let topVC = UIViewController.topViewController {
                let vc = DetailVoucherViewController.makeMe()
                vc.voucherId = hotVouchers[indexPath.item + 1].id
                topVC.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeHotVoucherView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetween2Items
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let sectionType = HomeHotVoucherSection(rawValue: section) else {
            return .zero
        }
        
        switch sectionType {
        case .banner:
            return UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: 0, right: 0)
        case .hot:
            return UIEdgeInsets(top: 0, left: Constants.spaceBetween2Items, bottom: 0, right: Constants.horizontalPadding)
        }
    }
}
