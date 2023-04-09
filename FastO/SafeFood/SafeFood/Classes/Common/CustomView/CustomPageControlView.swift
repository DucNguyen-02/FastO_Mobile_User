//
//  CustomPageControlView.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 7/28/22.
//

import UIKit

final class CustomPageControlView: UIView {
    @IBInspectable var color: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }

    var numberOfPages: Int = 0 {
        didSet {
            setupNumberOfPages()
        }
    }

    var currentIndex: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    let pageControlWidth = UIScreen.main.bounds.width - 32
    private let progressLayer = CALayer()
    private let backgroundMask = CAShapeLayer()
    private var itemWidth: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
}

// MARK: - LifeCycle
extension CustomPageControlView {
    override func draw(_ rect: CGRect) {
        if numberOfPages <= 1 {
            isHidden = true
            return
        }
        isHidden = false
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: 0).cgPath
        layer.mask = backgroundMask

        let progressRect = CGRect(origin: CGPoint(x: CGFloat(currentIndex) * itemWidth, y: 0), size: CGSize(width: itemWidth, height: rect.height))

        progressLayer.frame = progressRect
        progressLayer.backgroundColor = color.cgColor
    }
}

// MARK: - Helper
extension CustomPageControlView {
    private func setupLayers() {
        backgroundColor = R.color.grayD9D9D9()
        layer.addSublayer(progressLayer)
    }

    private func setupNumberOfPages() {
        if numberOfPages > 0 {
            if frame.size.width > 0 {
                itemWidth = frame.size.width / CGFloat(numberOfPages)
            } else {
                if (superview?.frame) != nil {
                    let pageControlWidth = UIScreen.main.bounds.width - 32
                    itemWidth = CGFloat(pageControlWidth) / CGFloat(numberOfPages)
                } else {
                    itemWidth = CGFloat(pageControlWidth) / CGFloat(numberOfPages)
                }
            }
        }
        setNeedsDisplay()
    }
}
