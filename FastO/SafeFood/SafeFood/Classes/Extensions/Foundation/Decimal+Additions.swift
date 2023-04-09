import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
    
    var floatValue: Float {
        return NSDecimalNumber(decimal: self).floatValue
    }
    
    func formatToString(decimalPlaces: Int = 2) -> String? {
        formatToString(minimumFractionDigits: decimalPlaces, maximumFractionDigits: decimalPlaces)
    }
    
    func formatToString(minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.numberStyle = .decimal
        
        return formatter.string(from: self as NSDecimalNumber)
    }
    
    func round(places: Int, mode: RoundingMode) -> Decimal {
        var result = Decimal()
        var value = self
        NSDecimalRound(&result, &value, places, mode)
        return result
    }
}
