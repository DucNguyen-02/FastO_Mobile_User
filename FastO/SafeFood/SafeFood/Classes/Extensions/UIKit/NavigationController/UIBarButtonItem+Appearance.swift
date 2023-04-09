import UIKit

public extension UIBarButtonItem {
  
  class func daPassBackButton(target: Any?, action: Selector?) -> UIBarButtonItem {
    let backIcon = R.image.icBack()
    let item = UIBarButtonItem(image: backIcon, style: .done, target: target, action: action)
    item.imageInsets = UIEdgeInsets(top: 3, left: -6, bottom: 0, right: 0)
    return item
  }
}
