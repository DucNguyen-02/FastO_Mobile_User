import UIKit

final class SettingViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var accountView: UIStackView!
    @IBOutlet private weak var changePasswordView: UIStackView!
    @IBOutlet private weak var languageView: UIStackView!
    @IBOutlet private weak var helpView: UIStackView!
    @IBOutlet private weak var nameUserLabel: UILabel!
    @IBOutlet private weak var avatarImageView: BaseImageView!
    
    // MARK: - Private Variable
    
    private var config = ImagePickerHelper.shared.defaultConfig!
    private var defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private lazy var presenter: SettingPresenter = {
        let presenter = SettingPresenter()
        presenter.view = self
        return presenter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - IBAction
    
    @IBAction private func signOutButtonTapped(_ sender: Any) {
        presenter.onViewDidLoad()
    }
}

// MARK: - Private

private extension SettingViewController {
    func setupUI() {
        actionAccount()
        actionChangePassword()
        guard let user = defaultsStorage.user else { return }
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)
        avatarImageView.setImage(with: user.userImage, placeholderImage: R.image.icPlaceholderImg())
        avatarImageView.setCornerDefaultStyle()
        nameUserLabel.text = user.firstName + " " + user.lastName
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeAvatar))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    func actionAccount() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAccountView))
        accountView.addGestureRecognizer(tap)
    }
    
    @objc func handleAccountView() {
        if let topVC = UIViewController.topViewController() {
            let vc = ProfileViewController()
            topVC.pushViewController(vc, animated: true)
        }
    }
    
    @objc func changeAvatar() {
        showPhotoPicker()
    }
    
    func actionChangePassword() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePasswordView))
        changePasswordView.addGestureRecognizer(tap)
    }
    
    @objc func handleChangePasswordView() {
        if let topVC = UIViewController.topViewController() {
            let vc = ChangePasswordViewController()
            topVC.pushViewController(vc, animated: true)
        }
    }
    
    func showPhotoPicker() {
        guard let topVC = UIViewController.topViewController() else { return }
        config.library.maxNumberOfItems = 1
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

// MARK: - SettingViewInput

extension SettingViewController: SettingViewInput {
    func reloadData() {
        guard let account = presenter.account else { return }
        avatarImageView.setImage(with: account.userImage, placeholderImage: R.image.icPlaceholderImg())
        avatarImageView.setCornerDefaultStyle()
    }
}
