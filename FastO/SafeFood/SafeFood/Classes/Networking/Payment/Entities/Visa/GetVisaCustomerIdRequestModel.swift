import Foundation
import SwiftyJSON

struct GetVisaCustomerIdRequestModel: Encodable {
    let cardNumber: String
    let cvc: String
    let description: String
    let email: String
    let expMonth: Int
    let expYear: Int
    let name: String
}
