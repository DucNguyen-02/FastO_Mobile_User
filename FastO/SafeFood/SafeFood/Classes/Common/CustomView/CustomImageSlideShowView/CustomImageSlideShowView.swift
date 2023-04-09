//
//  CustomImageSlideShowView.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 7/28/22.
//

import UIKit
import ImageSlideshow
import Kingfisher

final class CustomImageSlideShowView: UIView {

    private var imageSlideShow: ImageSlideshow!
    private var pageControl: CustomPageControlView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImageSlideShow()
        setUpPageControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Public
extension CustomImageSlideShowView {
    func setBanners(url: [String], isHomeBanner: Bool = true) {
        var imageSources = [KingfisherSource]()

        for i in 0..<url.count {
            if let source = KingfisherSource(urlString: url[i]) {
                imageSources.append(source)
            }
        }

        pageControl.numberOfPages = url.count
        imageSlideShow.backgroundColor = R.color.grayD9D9D9()
        imageSlideShow.pageIndicator = nil
        imageSlideShow.contentScaleMode = .scaleAspectFill
        imageSlideShow.setImageInputs(imageSources)
        imageSlideShow.slideshowInterval = 5
        imageSlideShow.currentPageChanged = { [weak self] index in
            self?.pageControl.currentIndex = index
        }
    }
}

// MARK: - Private
private extension CustomImageSlideShowView {
    func setUpImageSlideShow() {
        imageSlideShow = ImageSlideshow()
        imageSlideShow.scrollView.contentInsetAdjustmentBehavior = .never
        addSubview(imageSlideShow)
        imageSlideShow.translatesAutoresizingMaskIntoConstraints = false
        imageSlideShow.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageSlideShow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        imageSlideShow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        imageSlideShow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        imageSlideShow.cornerRadius = 10

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
    }

    func setUpPageControl() {
        pageControl = CustomPageControlView()
        addSubview(pageControl)
        let pageControlWidth = UIScreen.main.bounds.width - 32

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.widthAnchor.constraint(equalToConstant: CGFloat(pageControlWidth)).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 2).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: imageSlideShow.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        bringSubviewToFront(pageControl)
    }

    @objc func didTap() {
    }
}
