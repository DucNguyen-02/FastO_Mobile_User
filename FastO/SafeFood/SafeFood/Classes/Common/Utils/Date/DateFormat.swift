import Foundation

enum DateFormat {
    case date
    case monthDate
    case monthDateShorted
    case monthYear
    case monthYearShorted
    case fullDate
    case fullDate12HourPeriod
    case fullDateAndSecond
    case fullDateSlashed
    case isoFullDate
    case isoReversed
    case iso8601
    case iso8601Full
    case iso8601Short
    case monthDateTimeShorted
    case timeIn12HourPeriod
    case timeIn12HourPeriodWithoutSpace
    case dayWithDate
}

extension DateFormat: DateFormatsFactory {
    // swiftlint:disable cyclomatic_complexity
    func formatString() -> String {
        switch self {
        case .date:
            return "dd MMM yyyy"
        case .monthDate:
            return "dd MMMM"
        case .monthDateShorted:
            return "dd MMM"
        case .monthYear:
            return "MMMM yyyy"
        case .monthYearShorted:
            return "MMM yyyy"
        case .fullDate:
            return "d MMM yyyy, hh:mma"
        case .fullDate12HourPeriod:
            return "d MMM yyyy, h:mm a"
        case .fullDateAndSecond:
            return "d MMM yyy, hh:mm:ss a"
        case .fullDateSlashed:
            return "dd/MM/yyyy hh:mm:ss a"
        case .isoFullDate:
            return "dd/MM/yyyy"
        case .isoReversed:
            return "dd-MM-yyyy"
        case .iso8601:
            return "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        case .iso8601Full:
            return "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        case .iso8601Short:
            return "yyyy-MM-dd"
        case .monthDateTimeShorted:
            return "dd MMM, hh.mma"
        case .timeIn12HourPeriod:
            return "h:mm a"
        case .timeIn12HourPeriodWithoutSpace:
            return "h:mma"
        case .dayWithDate:
            return "EEEE, d MMM yyyy"
        }
    }
}

private extension DateFormat {
    var locale: Locale {
        return Locale.current
    }
    
    func localizedFormat(for format: String) -> String? {
        return DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: locale)
    }
}

protocol DateFormatsFactory {
    func formatString() -> String
}
