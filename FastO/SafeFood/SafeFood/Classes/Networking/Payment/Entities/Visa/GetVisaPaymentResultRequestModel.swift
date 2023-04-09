import Foundation
import SwiftyJSON

struct GetVisaPaymentResultRequestModel: Encodable {
    let amount: Int
    let currency: String
    let customerId: String
    let description: String
    let orderId: String
}
