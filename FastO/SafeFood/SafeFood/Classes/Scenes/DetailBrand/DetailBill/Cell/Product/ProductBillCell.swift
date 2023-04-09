//
//  ProductBillCell.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/6/22.
//

import UIKit

final class ProductBillCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var productImageView: BaseImageView!
    @IBOutlet private weak var nameProductLabel: UILabel!
    @IBOutlet private weak var quantityOfProductLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    // MARK: - Public Variable

    var imageURL: String? {
        didSet {
            productImageView.setImage(with: imageURL.orEmpty, placeholderImage: R.image.icPlaceholderImg())
        }
    }

    var name: String? {
        didSet {
            nameProductLabel.text = name
        }
    }

    var quantity: Int? {
        didSet {
            quantityOfProductLabel.text = "x\(quantity.orEmpty)"
        }
    }

    var price: Int? {
        didSet {
            priceLabel.text = formatToString(number: price.orEmpty) + "VNĐ"
        }
    }
}
