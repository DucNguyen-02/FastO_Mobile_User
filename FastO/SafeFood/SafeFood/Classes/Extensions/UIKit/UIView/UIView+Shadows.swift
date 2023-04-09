import UIKit

extension UIView {
    func addRoundShadow(radius: CGFloat, size: CGSize, shadowRadius: CGFloat, color: UIColor, opacity: CGFloat) {
        
        self.clipsToBounds = true
        
        layer.cornerRadius = radius
        layer.masksToBounds = false
        
        layer.shadowOffset = size
        layer.shadowColor = color.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = Float(opacity)
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
        
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        var rect = bounds
        
        // Increase height (only useful for the iPhone X for now)
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                rect.size.height += window.safeAreaInsets.bottom
            }
        }
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
