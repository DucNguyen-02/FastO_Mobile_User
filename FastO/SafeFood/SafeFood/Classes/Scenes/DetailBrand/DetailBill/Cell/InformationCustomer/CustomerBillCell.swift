//
//  CustomerBillCell.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/6/22.
//

import UIKit

final class CustomerBillCell: UITableViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var avatarImageView: BaseImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    @IBOutlet private weak var addressLabel: UILabel!
}

// MARK: - Public

extension CustomerBillCell {
    func setupData(bill: DetailBillModel) {
        avatarImageView.setImage(with: bill.logo, placeholderImage: R.image.icPlaceholderImg())
        nameLabel.text = bill.shopName
        addressLabel.text = bill.town + " " + bill.street + ", " + bill.city
    }
}
