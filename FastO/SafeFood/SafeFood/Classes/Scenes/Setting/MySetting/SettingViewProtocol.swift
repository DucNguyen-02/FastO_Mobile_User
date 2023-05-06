import UIKit

protocol SettingViewInput: AnyObject {
    func reloadData()
}

protocol SettingViewOutput: AnyObject {
    func onViewDidLoad()
    func onUploadImage(images: [UIImage])
}
