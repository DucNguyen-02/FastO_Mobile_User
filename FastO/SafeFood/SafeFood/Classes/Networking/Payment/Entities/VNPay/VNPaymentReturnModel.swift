import Foundation
import SwiftyJSON

struct VNPaymentReturnModel {
    let message: String
    let responseCode: String
    let signData: String

    init(json: JSON) {
        message = json["message"].stringValue
        responseCode = json["responseCode"].stringValue
        signData = json["signData"].stringValue
    }
}
