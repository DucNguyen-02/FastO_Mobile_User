//
//  VoucherBillCell.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/6/22.
//

import UIKit

final class VoucherBillCell: UITableViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var voucherImageView: BaseImageView!
    @IBOutlet private weak var nameVoucherLabel: UILabel!
    @IBOutlet private weak var discountPercentLabel: UILabel!
    @IBOutlet private weak var discountAmountLabel: UILabel!

    // MARK: - Public

    var imageURL: String? {
        didSet {
            voucherImageView.setImage(with: imageURL.orEmpty, placeholderImage: R.image.icPlaceholderImg())
        }
    }

    var name: String? {
        didSet {
            nameVoucherLabel.text = name
        }
    }

    func discount(type: VoucherType, discount: Int) {
        switch type {
        case .percent:
            discountAmountLabel.isHidden = true
            discountPercentLabel.isHidden = false
            discountPercentLabel.text = "-\(discount)%"

        case .amount:
            discountAmountLabel.isHidden = false
            discountPercentLabel.isHidden = true
            discountAmountLabel.text = "-\(formatToString(number: discount))VNĐ"
        }
    }
}
