//
//  CreateCommunityViewController.swift
//  SafeFood
//
//  Created by Zipris on 23/11/2022.
//  
//

import UIKit

final class CreateCommunityViewController: BaseViewController {
    
    struct Constants {
        static let horizontalPadding: CGFloat = 16
        static let spaceBetween2Items: CGFloat = 16
        static let designItemSize = CGSize(width: 302, height: 180)
        static let designScreenWidth: CGFloat = 375
        static var itemSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = screenWidth / designScreenWidth
            let itemWidth = designItemSize.width * ratio
            let itemHeight = designItemSize.height * ratio
            return CGSize(width: itemWidth, height: itemHeight)
        }()
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var screenLabel: UILabel!
    @IBOutlet private weak var collectionView: BaseCollectionView!
    @IBOutlet private weak var contentTextView: PlaceholderTextView!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var chooseShopButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: BaseImageView!
    @IBOutlet private weak var heightCollectionView: NSLayoutConstraint!
    
    // MARK: - Private Variable
    
    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private var config = ImagePickerHelper.shared.defaultConfig!
    private var shopId: Int?
    private var reviewId: Int?
    private lazy var presenter: CreateCommunityPresenter = {
      let presenter = CreateCommunityPresenter()
      presenter.view = self
      return presenter
    }()
    
    // MARK: - Public Variable
    
    var type: ScreenCommunityType = .new
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - IBAction
    
    @IBAction private func chosenShopButton(_ sender: Any) {
        if let topVC = UIViewController.topViewController() {
            let vc = ShopCommunityViewController.makeMe()
            vc.delegate = self
            topVC.present(vc, animated: true)
        }
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        popViewController(with: .revealFromBottom)
    }
    
    @IBAction private func addPhotoButtonTapped(_ sender: Any) {
        if presenter.imageUrls.count < 10 {
            showPhotoPicker()
        } else {
            ToastHelper.showToast("Ít nhất 1 ảnh và giới hạn là 10 ảnh")
        }
    }
    
    @IBAction private func postButtonTapped(_ sender: Any) {
        guard let shopId = shopId else { return }
        let create = CreateCommunityModel(shopId: shopId, content: contentTextView.text.orEmpty, reviewImages: presenter.imageUrls, title: titleTextField.text.orEmpty)
        
        presenter.onViewDidLoad(create.toDictionary(), id: reviewId, type: type)
    }
}

// MARK: - Private

private extension CreateCommunityViewController {
    func setupUI() {
        collectionView.isHidden = true
        collectionView.register(ImageCreateCommunityCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.horizontalPadding, bottom: 0, right: Constants.horizontalPadding)
        heightCollectionView.constant = Constants.itemSize.height
        guard let user = defaultsStorage.user  else { return }
        avatarImageView.setImage(with: user.userImage, placeholderImage: R.image.icPlaceholderImg())
        avatarImageView.setCornerDefaultStyle()
        nameLabel.text = user.firstName + " " + user.lastName
    }
    
    func showPhotoPicker() {
        guard let topVC = UIViewController.topViewController() else { return }
        config.library.maxNumberOfItems = 10
        config.startOnScreen = .photo
        config.library.mediaType = .photo
        config.screens = [.photo, .library]
        config.showsPhotoFilters = false
        ImagePickerHelper.shared.showImagesPicker(inViewController: topVC, config: config) { [weak self] images, _ in
            guard let self = self else { return }
            if let images = images {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter.onUploadImage(images: images)
                }
            }
        }
    }
}

// MARK: - Public

extension CreateCommunityViewController {
    func setupData(id: Int) {
        self.reviewId = id
        presenter.onGetDetailCommunity(id: id)
    }
}

// MARK: - UICollectionViewDataSource

extension CreateCommunityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.imageUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ImageCreateCommunityCell.self, for: indexPath)
        cell.delegate = self
        cell.setupData(image: presenter.imageUrls[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreateCommunityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetween2Items
    }
}

// MARK: - CreateCommunityDelegate

extension CreateCommunityViewController: CreateCommunityDelegate {
    func removeImage(image: String) {
        presenter.imageUrls.removeAll { $0 == image }
        collectionView.isHidden = presenter.imageUrls.isEmpty
        collectionView.reloadData()
    }
    
    func chooseShop(brand: BrandModel) {
        chooseShopButton.setTitle(brand.name, for: .normal)
        shopId = brand.id
    }

}

// MARK: - CreateCommunityViewInput

extension CreateCommunityViewController: CreateCommunityViewInput {
    func popViewController() {
        popViewController(with: .moveInFromBottom)
    }
    
    func reloadCollectionViewData() {
        collectionView.isHidden = presenter.imageUrls.isEmpty
        collectionView.reloadData()
    }
    
    func reloadData() {
        guard let community = presenter.community else { return }
        collectionView.isHidden = presenter.imageUrls.isEmpty
        presenter.imageUrls =  community.images
        contentTextView.text = community.content
        titleTextField.text = community.title
        shopId = community.shop.id
        chooseShopButton.setTitle(community.shop.name, for: .normal)
        collectionView.reloadData()
    }
}
