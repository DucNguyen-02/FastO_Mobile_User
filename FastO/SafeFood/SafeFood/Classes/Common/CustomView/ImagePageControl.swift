//
//  ImagePageControl.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 7/28/22.
//

import UIKit

final class ImagePageControl: UIStackView {
    
    var currentPageImage: UIImage? = R.image.page_black()
    var pageImage: UIImage? = R.image.page_gray()
    /**
     Sets how many page indicators will show
     */
    var numberOfPages = 3 {
        didSet {
            layoutIndicators()
        }
    }
    /**
     Sets which page indicator will be highlighted with the **currentPageImage**
     */
    var currentPage = 0 {
        didSet {
            setCurrentPageIndicator()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        spacing = 2
        distribution = .fillEqually
        alignment = .center
        layoutIndicators()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension ImagePageControl {
    override func awakeFromNib() {
        super.awakeFromNib()

        axis = .horizontal
        distribution = .fillEqually
        alignment = .center

        layoutIndicators()
    }
}

// MARK: - Helper
extension ImagePageControl {
    private func layoutIndicators() {

        for i in 0..<numberOfPages {

            let imageView: BaseImageView

            if i < arrangedSubviews.count {
                imageView = arrangedSubviews[i] as! BaseImageView // reuse subview if possible
            } else {
                imageView = BaseImageView()
                addArrangedSubview(imageView)
            }

            imageView.contentMode = .scaleAspectFit

            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }

        // remove excess subviews if any
        let subviewCount = arrangedSubviews.count
        if numberOfPages < subviewCount {
            for _ in numberOfPages..<subviewCount {
                arrangedSubviews.last?.removeFromSuperview()
            }
        }
    }
    
    private func setCurrentPageIndicator() {
        
        for i in 0..<arrangedSubviews.count {
            
            let imageView = arrangedSubviews[i] as! BaseImageView
            
            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
    }
}
