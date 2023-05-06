import UIKit

final class ProfilePresenter {

    // MARK: - Private Variable
    
    private let imageFolderType: ImageFolderType = .user

    // MARK: - Public Variable
    
    var imageUrls: [String] = []
    var account: AccountProfileModel?
    weak var view: ProfileViewInput?
}

// MARK: - SettingViewOutput

extension ProfilePresenter: ProfileViewOutput {
    func onViewDidLoad() {
        getInformation()
    }
    
    func onUpdate(_ info: [String : Any]) {
        postInformation(info)
    }
    
    func onUploadImage(images: [UIImage]) {
        uploadImage(images: images)
    }
}

// MARK: - Private

private extension ProfilePresenter {
    func getInformation() {
        UserService.shared.getUserProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(account):
                self.account = account
                self.view?.reloadData()
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
    
    func postInformation(_ info: [String: Any]) {
        UserService.shared.postProfile(info) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(account):
                self.account = account
                self.view?.reloadData()
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
    
    func uploadImage(images: [UIImage]) {
        UploadImageService.shared.uploadImage(images: images, type: imageFolderType.type) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(images):
                self.imageUrls = images
                self.changeAvatar(avatar: images[safe: 0].orEmpty)
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
    
    func changeAvatar(avatar: String) {
        UserService.shared.changeAvatar(avatar: avatar) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view?.reloadAvatar()

            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
}
