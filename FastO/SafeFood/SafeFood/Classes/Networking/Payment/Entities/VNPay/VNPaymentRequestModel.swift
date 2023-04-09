import Foundation
import SwiftyJSON

struct VNPaymentRequestModel: Encodable {
    let bankCode: String
    let billId: Int
    let vnpLocale: String
    let vnpOderType: String // FIXME: Waiting BE to update vnpOrderType
    let vnpReturnUrl: String
}
