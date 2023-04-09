//
//  DetailBillHeaderView.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/6/22.
//

import UIKit

final class DetailBillHeaderView: UITableViewHeaderFooterView {

    // MARK: - IBOutlet

    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var titleHeaderLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    // MARK: - Public Variable


    var line: Bool? {
        didSet {
            lineView.isHidden = line ?? false
        }
    }
    var title: String? {
        didSet {
            titleHeaderLabel.text = title.orEmpty
        }
    }

    var value: Int? {
        didSet {
            if let value = value {
                valueLabel.isHidden = false
                valueLabel.text = formatToString(number: value) + "VNĐ"
            } else {
                valueLabel.isHidden = true
            }
        }
    }
}
