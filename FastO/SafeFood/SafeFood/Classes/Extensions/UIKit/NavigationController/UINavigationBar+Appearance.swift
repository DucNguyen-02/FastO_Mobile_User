import UIKit

public extension UINavigationBar {
  
  func applyDaPassAppearance() {
    
    barTintColor = .white
    tintColor = .white
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = 26
    var titleAttributes: [NSAttributedString.Key: Any] = [
      .font: R.font.lexendMedium(size: 18)!,
      .paragraphStyle: paragraphStyle
    ]
    titleAttributes[.foregroundColor] = R.color.black100() ?? .black
    if #available(iOS 13.0, *) {
      standardAppearance.titleTextAttributes = titleAttributes
    } else {
      titleTextAttributes = titleAttributes
    }
    
    shadowIsHidden = true
  }
  
  /// https://dmtopolog.com/navigation-bar-customisation-2/
  /// Detailed article on how shadow behave differenly on different iOS version
  var shadowIsHidden: Bool {
    get {
      if #available(iOS 13.0, *) {
        return standardAppearance.shadowColor == nil
      } else {
        return shadowImage != nil
      }
    }
    
    set {
      guard shadowIsHidden != newValue else { return }
      
      let newShadowImage = newValue ? UIImage() : nil
      let newShadowColor = newValue ? nil : UIColor.lightGray.withAlphaComponent(0.7)
      if #available(iOS 13.0, *) {
        standardAppearance.backgroundColor = barTintColor
        standardAppearance.shadowColor = newShadowColor
      } else {
        shadowImage = newShadowImage
      }
    }
  }
}
