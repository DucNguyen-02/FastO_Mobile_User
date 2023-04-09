import Foundation

private struct DateFormatterCacheKey {
    static let dateFormatter = "DateFormatterCache.Date"
    static let monthDateFormatter = "DateFormatterCache.MonthDate"
    static let monthDateShortedFormatter = "DateFormatterCache.MonthDateShorted"
    static let monthYearFormatter = "DateFormatterCache.MonthYear"
    static let monthYearShortedFormatter = "DateFormatterCache.MonthYearShorted"
    static let fullDateFormatter = "DateFormatterCache.FullDate"
    static let fullDate12HourFormatter = "DateFormatterCache.fullDate12HourPeriod"
    static let fullDateAndSecond = "DateFormatterCache.fullDateAndSecond"
    static let fullDateSlashedFormatter = "DateFormatterCache.FullDateSlashed"
    static let isoReversedFormatter = "DateFormatterCache.isoReversed"
    static let iso8601Formatter = "DateFormatterCache.iso8601"
    static let iso8601FullFormatter = "DateFormatterCache.iso8601Full"
    static let iso8601ShortFormatter = "DateFormatterCache.iso8601Short"
    static let monthDateTimeShortedFormatter = "DateFormatterCache.MonthDateTimeShorted"
    static let timeIn12HourPeriodFormatter = "DateFormatterCache.TimeIn12HourPeriod"
    static let timeIn12HourPeriodWithoutSpaceFormatter = "DateFormatterCache.TimeIn12HourPeriodWithoutSpace"
    static let dayWithDate = "DateFormatterCache.DayWithDate"
}

enum DateFormatterCache {
    case date
    case monthDate
    case monthDateShorted
    case monthYear
    case monthYearShorted
    case fullDate
    case fullDate12HourPeriod
    case fullDateAndSecond
    case fullDateSlashed
    case isoReversed
    case iso8601
    case iso8601Full
    case iso8601Short
    case monthDateTimeShorted
    case timeIn12HourPeriod
    case timeIn12HourPeriodWithoutSpace
    case dayWithDate
    
}

extension DateFormatterCache {
    func formatter() -> DateFormatterType {
        if let cached = Thread.current.threadDictionary[cacheKey()] {
            return cached as! DateFormatterType
        } else {
            let formatter = buildFormatter()
            Thread.current.threadDictionary[cacheKey()] = formatter
            return formatter
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    private func cacheKey() -> String {
        switch self {
        case .date:
            return DateFormatterCacheKey.dateFormatter
        case .monthDate:
            return DateFormatterCacheKey.monthDateFormatter
        case .monthDateShorted:
            return DateFormatterCacheKey.monthDateShortedFormatter
        case .monthYear:
            return DateFormatterCacheKey.monthYearFormatter
        case .monthYearShorted:
            return DateFormatterCacheKey.monthYearShortedFormatter
        case .fullDate:
            return DateFormatterCacheKey.fullDateFormatter
        case .fullDate12HourPeriod:
            return DateFormatterCacheKey.fullDate12HourFormatter
        case .fullDateAndSecond:
            return DateFormatterCacheKey.fullDateAndSecond
        case .fullDateSlashed:
            return DateFormatterCacheKey.fullDateSlashedFormatter
        case .isoReversed:
            return DateFormatterCacheKey.isoReversedFormatter
        case .iso8601:
            return DateFormatterCacheKey.iso8601Formatter
        case .iso8601Full:
            return DateFormatterCacheKey.iso8601FullFormatter
        case .iso8601Short:
            return DateFormatterCacheKey.iso8601ShortFormatter
        case .monthDateTimeShorted:
            return DateFormatterCacheKey.monthDateTimeShortedFormatter
        case .timeIn12HourPeriod:
            return DateFormatterCacheKey.timeIn12HourPeriodFormatter
        case .timeIn12HourPeriodWithoutSpace:
            return DateFormatterCacheKey.timeIn12HourPeriodWithoutSpaceFormatter
        case .dayWithDate:
            return DateFormatterCacheKey.dayWithDate
        }
    }
    
    private func buildFormatter() -> DateFormatterType {
        switch self {
        case .date:
            return DateFormatter.date()
        case .monthDate:
            return DateFormatter.monthDate()
        case .monthDateShorted:
            return DateFormatter.monthDateShorted()
        case .monthYear:
            return DateFormatter.monthYear()
        case .monthYearShorted:
            return DateFormatter.monthYearShorted()
        case .fullDate:
            return DateFormatter.fullDate()
        case .fullDate12HourPeriod:
            return DateFormatter.fullDate12HourPeriod()
        case .fullDateAndSecond:
            return DateFormatter.fullDateAndSecond()
        case .fullDateSlashed:
            return DateFormatter.fullDateSlashed()
        case .isoReversed:
            return DateFormatter.isoReversed()
        case .iso8601:
            return DateFormatter.iso8601()
        case .iso8601Full:
            return DateFormatter.iso8601Full()
        case .iso8601Short:
            return DateFormatter.iso8601Short()
        case .monthDateTimeShorted:
            return DateFormatter.monthDateTimeShorted()
        case .timeIn12HourPeriod:
            return DateFormatter.timeIn12HourPeriod()
        case .timeIn12HourPeriodWithoutSpace:
            return DateFormatter.timeIn12HourPeriodWithoutSpace()
        case .dayWithDate:
            return DateFormatter.dayWithDate()
        }
    }
}
