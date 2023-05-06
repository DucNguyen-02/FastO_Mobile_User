import Foundation
import SVProgressHUD

final class SettingPresenter {
    
    // MARK: - Private Variable
    
    private let notificationCenter: NotificationCenterService = NotificationCenter.default
    private let imageFolderType: ImageFolderType = .user
    
    // MARK: - Public Variable
    
    var imageUrls: [String] = []
    var account: AccountProfileModel?
    weak var view: SettingViewInput?
}

// MARK: - SettingViewOutput

extension SettingPresenter: SettingViewOutput {
    func onViewDidLoad() {
        logout()
    }
    
    func onUploadImage(images: [UIImage]) {
        uploadImage(images: images)
    }
}


private extension SettingPresenter {
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
    
    func uploadImage(images: [UIImage]) {
        SVProgressHUD.show()
        UploadImageService.shared.uploadImage(images: images, type: imageFolderType.type) { [weak self] result in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case let .success(images):
                self.imageUrls =  images
                self.changeAvatar(avatar: images[safe: 0].orEmpty)
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func changeAvatar(avatar: String) {
        UserService.shared.changeAvatar(avatar: avatar) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.getInformation()
                
            case let .failure(error):
                ToastHelper.showToast(error.message)
            }
        }
    }
    
    func logout() {
        AuthenService.shared.logout { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.notificationCenter.post(name: AccountNotifications.accountLoggedOut, object: nil)
                
            case let .failure(error):
                ToastHelper.showError(error.message)
                self.notificationCenter.post(name: AccountNotifications.accountLoggedOut, object: nil)
            }
        }
    }
}
