import UIKit

protocol ManagerViewInput: AnyObject {
    
}

protocol ManagerViewOutput: AnyObject {
    func onViewDidLoad()
}

enum MyManagerType: Int, CaseIterable {
    case buyed = 0
    case used
    case error
    case saved
    
    var title: String {
        switch self {
        case .buyed:
            return "Buyed"
        case .used:
            return "Used"
        case .error:
            return "Error"
        case .saved:
            return "Favourite"
        }
    }
    
    var imageEmpty: UIImage? {
        return R.image.ic_dapass_logo()
    }
    
    var titleEmpty: NSAttributedString? {
        var text: String?
        var font: UIFont?
        var textColor: UIColor?
        switch self {
        case .buyed, .used, .error:
            text = "No have order"
            font = R.font.lexendRegular(size: 12)
            textColor = R.color.grayA2A2A3() ?? .gray
        case .saved:
            text = "You haven't favourite shop"
            font = R.font.lexendRegular(size: 12)
            textColor = R.color.grayA2A2A3() ?? .gray
        }
        if text == nil {
            return nil
        }
        var attributes: [NSAttributedString.Key: Any] = [:]
        if font != nil {
            attributes[NSAttributedString.Key.font] = font!
        }
        if textColor != nil {
            attributes[NSAttributedString.Key.foregroundColor] = textColor
        }
        return NSAttributedString.init(string: text!, attributes: attributes)
    }
    
    var color: UIColor? {
        switch self {
        case .buyed:
            return R.color.black100() ?? .black
        case .used, .error, .saved:
            return nil
        }
    }
}
