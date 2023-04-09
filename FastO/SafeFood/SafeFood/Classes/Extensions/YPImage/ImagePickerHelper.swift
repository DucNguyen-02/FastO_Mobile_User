import UIKit
import YPImagePicker

class ImagePickerHelper: NSObject {
    
    static var shared = ImagePickerHelper()

    var defaultConfig: YPImagePickerConfiguration! {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.itemOverlayType = .none
        config.usesFrontCamera = true
        config.shouldSaveNewPicturesToAlbum = false
        config.albumName = "SAFEFOOD"
        config.startOnScreen = .photo
        config.screens = [.photo, .library]
        config.showsPhotoFilters = false

        /* Customize wordings */
        config.wordings.done = "Xong"
        config.wordings.libraryTitle = "Bộ sưu tập"
        config.wordings.cameraTitle = "Chụp ảnh"
        config.wordings.cancel = "Huỷ"
        config.wordings.filter = "Bộ lọc"
        config.wordings.next = "Tiếp tục"
        config.wordings.done = "Xong"
        config.wordings.save = "Lưu"
        config.wordings.trim = "Trim"
        config.fonts.pickerTitleFont = R.font.lexendBold(size: 18)!
        config.fonts.leftBarButtonFont = R.font.lexendBold(size: 16)!
        config.fonts.rightBarButtonFont = R.font.lexendBold(size: 16)!
        config.fonts.menuItemFont = R.font.lexendBold(size: 16)!
        config.fonts.navigationBarTitleFont = R.font.lexendBold(size: 16)!
        config.usesFrontCamera = false
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = 1
        config.maxCameraZoomFactor = 2.0
        config.gallery.hidesRemoveButton = false
        config.library.isSquareByDefault = false
        
        config.wordings.permissionPopup.title = "Truy cập bị từ chối"
        config.wordings.permissionPopup.message = "Vui lòng cho phép SAFEFOOD truy cập camera và thư viện hình ảnh để sử dụng trong ứng dụng"
        config.wordings.permissionPopup.grantPermission = "Cấp quyền"
        config.wordings.permissionPopup.cancel = "Huỷ"
        config.targetImageSize = .cappedTo(size: 720)
        return config
    }
    
    func showImagePicker(inViewController vc: UIViewController, config: YPImagePickerConfiguration = ImagePickerHelper.shared.defaultConfig, completion: @escaping(_ image: UIImage?, _ error: String?) -> Void) {
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in

            if cancelled {
                completion(nil, "Đã huỷ chọn ảnh".localized())
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            if items.count < 1 {
                completion(nil, "Bạn chưa chọn ảnh nào".localized())
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            if let item = items.first {
                var image: YPMediaPhoto!
                switch item {
                case .photo(let photo):
                    image = photo
                default:
                    break
                }
                DispatchQueue.main.async {
                    completion(image.image, nil)
                }
            } else {
                completion(nil, "Something went wrong")
            }
            picker.dismiss(animated: true, completion: nil)
        }

        vc.present(picker, animated: true, completion: nil)
    }
    
    func showImagesPicker(inViewController vc: UIViewController, config: YPImagePickerConfiguration = ImagePickerHelper.shared.defaultConfig, completion: @escaping(_ images: [UIImage]?, _ error: String?) -> Void) {
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in

            if cancelled {
                completion(nil, "Đã huỷ chọn ảnh".localized())
                picker.dismiss(animated: true, completion: nil)
                return
            }
            var photos = [UIImage]()
            
            for item in items {
                switch item {
                case .photo(let photo):
                    photos.append(photo.image)
                default:
                    break
                }
            }
            DispatchQueue.main.async {
                completion(photos, nil)
            }
            picker.dismiss(animated: true, completion: nil)
        }

        vc.present(picker, animated: true, completion: nil)
    }
}
