//
//  ImageCreateCommunityCell.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/20/22.
//

import UIKit

final class ImageCreateCommunityCell: UICollectionViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var chosenImageView: BaseImageView!
    @IBOutlet private weak var removeButton: BaseButton!

    // MARK: - Public Variable

    weak var delegate: CreateCommunityDelegate?
    private var image: String = ""

    // MARK: - IBAction

    @IBAction private func removeButtonTapped(_ sender: Any) {
        delegate?.removeImage(image: image)
    }
}

// MARK: - Public

extension ImageCreateCommunityCell {
    func setupData(image: String) {
        self.image = image
        chosenImageView.setImage(with: image, placeholderImage: R.image.icPlaceholderImg())
    }
}
