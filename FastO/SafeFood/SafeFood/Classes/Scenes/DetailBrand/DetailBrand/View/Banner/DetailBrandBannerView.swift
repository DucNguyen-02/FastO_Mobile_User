//
//  DetailBrandBannerView.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 9/6/22.
//

import UIKit

final class DetailBrandBannerView: NibView {
    
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

    @IBOutlet private weak var bannerView: SafeFoodBannerView!

    // MARK: - Public Variable

    var banners: [String] = [] {
        didSet {
            setupPagerView(with: banners)
        }
    }

    // MARK: - Life Cycle

    override func configureView() {
        super.configureView()

    }
}

// MARK: - Private

private extension DetailBrandBannerView {
    func setupPagerView(with banners: [String]) {
        let bannerImageUrls = banners
        bannerView.update(with: bannerImageUrls)
    }
}
