import WebKit
import Foundation

extension WKWebView {
    class func clean() {
        // Even we didn't support iOS below 9 but still put it here to remind this only available from iOS >= 9
        guard #available(iOS 9.0, *) else { return }
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {}
                #if DEBUG
                print("WKWebsiteDataStore record deleted:", record)
                #endif
            }
        }
    }
}
