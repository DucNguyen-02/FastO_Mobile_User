//
//  SafeFoodVoucherApplyRow.swift
//  SafeFood
//
//  Created by Zipris on 29/11/2022.
//

import UIKit

final class SafeFoodVoucherApplyRow: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var percentImageView: UIImageView!
    @IBOutlet private weak var discountAmountLabel: UILabel!
    @IBOutlet private weak var percentView: UIStackView!
    @IBOutlet private weak var discountPercentLabel: UILabel!
    @IBOutlet private weak var countUsedVoucherLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var nameVoucherLabel: UILabel!
    @IBOutlet private weak var avatarImageView: BaseImageView!
    @IBOutlet private weak var chooseButton: BaseButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let image = isSelected ? R.image.authenticationCheckmark() : R.image.authenticationCheckmarkEmpty()
        chooseButton.setImage(image, for: .normal)
    }
}

// MARK: - Public

extension SafeFoodVoucherApplyRow {
    func setupData(voucher: VoucherModel) {
        avatarImageView.setImage(with: voucher.image, placeholderImage: R.image.icPlaceholderImg())
        nameVoucherLabel.text = voucher.name
        descriptionLabel.text = voucher.description
        countUsedVoucherLabel.text = "Used to \(formatToString(number: voucher.countUserVoucher)) people - \(formatToString(number: voucher.quantity)) vouchers left"
        
        if voucher.voucherType == .percent {
            discountAmountLabel.isHidden = true
            percentImageView.isHidden = false
            percentView.isHidden = false
            discountPercentLabel.text = "\(voucher.valueDiscount)"
        } else {
            discountAmountLabel.isHidden = false
            percentImageView.isHidden = true
            percentView.isHidden = true
            discountAmountLabel.text = formatToString(number: voucher.valueDiscount) + "VNĐ"
        }
        chooseButton.setImage(R.image.authenticationCheckmarkEmpty(), for: .normal)
    }
}
