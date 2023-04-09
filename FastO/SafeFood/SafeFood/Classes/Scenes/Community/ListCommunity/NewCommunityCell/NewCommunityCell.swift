//
//  NewCommunityCell.swift
//  SafeFood
//
//  Created by Zipris on 23/11/2022.
//

import UIKit

final class NewCommunityCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var newTextField: BaseTextField!
    @IBOutlet private weak var avatarImageView: BaseImageView!
    
    // MARK: - Private Variable
    
    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let user = defaultsStorage.user else { return }
        avatarImageView.setImage(with: user.userImage, placeholderImage: R.image.icPlaceholderImg())
        avatarImageView.setCornerDefaultStyle()
    }
}
