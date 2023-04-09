import Foundation

protocol DateFormatterType {
    var dateFormat: String! { get set }
    var dateStyle: DateFormatter.Style { get set }
    
    func string(from date: Date) -> String
    func date(from string: String) -> Date?
    
    static func dateFormat(fromTemplate tmplate: String, options opts: Int, locale: Locale?) -> String?
}

extension DateFormatter: DateFormatterType {
}

extension DateFormatterType {
    static func date() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.date.formatString()
        return formatter
    }
    
    static func monthDate() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.date.formatString()
        return formatter
    }
    
    static func monthDateShorted() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.monthDateShorted.formatString()
        return formatter
    }
    
    static func monthYear() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.monthYear.formatString()
        return formatter
    }
    
    static func monthYearShorted() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.monthYearShorted.formatString()
        return formatter
    }
    
    static func fullDate() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        formatter.dateFormat = DateFormat.fullDate.formatString()
        return formatter
    }
    
    static func fullDate12HourPeriod() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = DateFormat.fullDate12HourPeriod.formatString()
        return formatter
    }
    
    static func fullDateAndSecond() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.fullDateAndSecond.formatString()
        return formatter
    }
    
    static func fullDateSlashed() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.fullDateSlashed.formatString()
        return formatter
    }
    
    static func monthDateTimeShorted() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.monthDateTimeShorted.formatString()
        return formatter
    }
    
    static func isoReversed() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.isoReversed.formatString()
        return formatter
    }
    
    static func iso8601() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = DateFormat.iso8601.formatString()
        return formatter
    }
    
    static func iso8601Full() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = DateFormat.iso8601Full.formatString()
        return formatter
    }
    
    static func iso8601Short() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = DateFormat.iso8601Short.formatString()
        return formatter
    }
    
    static func timeIn12HourPeriod() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.timeIn12HourPeriod.formatString()
        return formatter
    }
    
    static func timeIn12HourPeriodWithoutSpace() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = DateFormat.timeIn12HourPeriodWithoutSpace.formatString()
        return formatter
    }
    
    static func dayWithDate() -> DateFormatterType {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.dayWithDate.formatString()
        return formatter
    }
}
