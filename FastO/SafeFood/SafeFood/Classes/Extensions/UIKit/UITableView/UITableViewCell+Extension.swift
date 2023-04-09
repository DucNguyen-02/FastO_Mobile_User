import UIKit

extension UITableViewCell {
    class func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    class func nibName() -> String {
        return String(describing: self)
    }
    
    func formatToString(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true

        let number = NSNumber(value: number)
        let numberString = numberFormatter.string(from: number).orEmpty
        return numberString
    }
}

extension UITableViewHeaderFooterView {
    class func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    class func nibName() -> String {
        return String(describing: self)
    }
    
    func formatToString(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true

        let number = NSNumber(value: number)
        let numberString = numberFormatter.string(from: number).orEmpty
        return numberString
    }
}
