//
//  RatingOrderCell.swift
//  AppPass
//
//  Created by ADMIN on 22/11/2022.
//

import UIKit
import HCSStarRatingView

final class RatingOrderCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var ratingCell: UIView!
    @IBOutlet private weak var starView: HCSStarRatingView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Public
    
    weak var delegate: DetailBrandOrderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
}

// MARK: - Private

private extension RatingOrderCell {
    func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ratingAction))
        ratingCell.addGestureRecognizer(tap)
    }
    
    @objc func ratingAction() {
        delegate?.didRating()
    }
}

// MARK: - Public

extension RatingOrderCell {
    func setupData(rating: Double) {
        if rating <= 0 {
            ratingCell.isUserInteractionEnabled = true
            titleLabel.text = "Please rating your order"
            setupUI()
        } else {
            ratingCell.isUserInteractionEnabled = false
            starView.isHidden = false
            titleLabel.text = "Satisfaction Level"
            starView.value = CGFloat(rating)
        }
    }
}
