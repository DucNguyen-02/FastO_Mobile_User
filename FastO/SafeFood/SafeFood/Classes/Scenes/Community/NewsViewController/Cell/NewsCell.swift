//
//  NewsCell.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/20/22.
//

import UIKit

final class NewsCell: UITableViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var newImageView: BaseImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
}

// MARK: - Public

extension NewsCell {
    func setupData(news: HomeNewsModel) {
        newImageView.setImage(with: news.image, placeholderImage: R.image.icPlaceholderImg())
        titleLabel.text = news.title
        subTitleLabel.text = news.subTitle
    }
}
