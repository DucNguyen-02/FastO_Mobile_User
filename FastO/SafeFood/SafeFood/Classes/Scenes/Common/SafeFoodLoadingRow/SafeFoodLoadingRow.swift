//
//  SafeFoodLoadingRow.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 11/18/22.
//

import UIKit

final class SafeFoodLoadingRow: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicatorView.color = R.color.gray737374()
        activityIndicatorView.startAnimating()
    }
}
