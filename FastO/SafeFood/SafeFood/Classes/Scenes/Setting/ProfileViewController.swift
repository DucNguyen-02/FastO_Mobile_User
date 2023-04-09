//
//  ProfileViewController.swift
//  SafeFood
//
//  Created by ADMIN on 21/11/2022.
//

import UIKit
import YPImagePicker

final class ProfileViewController: BaseViewController {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var saveButton: BaseButton!
    @IBOutlet private weak var avatarImageView: BaseImageView!
    @IBOutlet private weak var firstNameLabel: BaseTextField!
    @IBOutlet private weak var genderTextField: BaseTextField!
    @IBOutlet private weak var birthdayTextField: BaseTextField!
    @IBOutlet private weak var lastNameTextField: BaseTextField!
    
    // MARK: - Private Variable
    
    private var config = ImagePickerHelper.shared.defaultConfig!
    private var imageUrls: String = ""
    private var birthdayDouble: Double = 0
    private lazy var presenter: ProfilePresenter = {
        let presenter = ProfilePresenter()
        presenter.view = self
        return presenter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.onViewDidLoad()
    }

    // MARK: - IBAction
    
    @IBAction private func saveButtonTapped(_ sender: Any) {
        let account = CreateAccountModel(firstName: firstNameLabel.text.orEmpty,
                                         lastName: lastNameTextField.text.orEmpty,
                                         gender: genderTextField.text.orEmpty,
                                         userImage: presenter.imageUrls.first.orEmpty,
                                         birthdayDouble: birthdayDouble)
        presenter.onUpdate(account.toDictionary())
    }
}

// MARK: - Private

private extension ProfileViewController {
    func setupUI() {
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)
        title = "Information"
        setupTextField()
        actionAvatar()
    }
    
    func setupTextField() {
        setupClearTextField(textField: firstNameLabel)
        setupClearTextField(textField: lastNameTextField)
        setupClearTextField(textField: birthdayTextField)
        setupClearTextField(textField: genderTextField)
    }

    func setupClearTextField(textField: UITextField) {
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        if let clearPasswordButton = textField.value(forKeyPath: "_clearButton") as? UIButton {
            clearPasswordButton.setImage(R.image.icClose(), for: .normal)
        }
    }
    
    func actionAvatar() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAvatar))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    @objc func handleAvatar() {
        showPhotoPicker()
    }
    
    func showPhotoPicker() {
        guard let topVC = UIViewController.topViewController() else { return }
        config.library.maxNumberOfItems = 1
        config.startOnScreen = .photo
        config.library.mediaType = .photo
        config.screens = [.photo, .library]
        config.showsPhotoFilters = false
        ImagePickerHelper.shared.showImagesPicker(inViewController: topVC, config: config) { [weak self] (images, _) in
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

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameLabel.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        birthdayTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()

        return true
    }
}

// MARK: - ProfileViewInput

extension ProfileViewController: ProfileViewInput {
    func reloadData() {
        guard let account = presenter.account else { return }
        firstNameLabel.text = account.firstName
        lastNameTextField.text = account.lastName
        imageUrls = account.userImage
        presenter.imageUrls = [account.userImage]
        birthdayDouble = account.birthdayDouble
        avatarImageView.setImage(with: account.userImage, placeholderImage: R.image.icPlaceholderImg())
        avatarImageView.setCornerDefaultStyle()
        genderTextField.text = account.gender
        birthdayTextField.text = "\(account.birthday)"
    }
    
    func reloadAvatar() {
        avatarImageView.setImage(with: presenter.imageUrls.first.orEmpty, placeholderImage: R.image.icPlaceholderImg())
    }
}
