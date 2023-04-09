import Foundation
import SwiftyJSON

struct VNPaymentResultRequestModel {
    let amount: Int
    let bankCode: String
    let bankTransactionNo: String
    let cardType: String
    let orderInfo: String
    let paymentDate: String
    let responseCode: String
    let tmnCode: String
    let transactionNo: String
    let transactionStatus: String
    let txnRef: String
    let secureHash: String
    
    init(query: [String: String]) {
        let json = JSON(query)
        amount = json["vnp_Amount"].intValue
        bankCode = json["vnp_BankCode"].stringValue
        bankTransactionNo = json["vnp_BankTranNo"].stringValue
        cardType = json["vnp_CardType"].stringValue
        orderInfo = json["vnp_OrderInfo"].stringValue
        paymentDate = json["vnp_PayDate"].stringValue
        responseCode = json["vnp_ResponseCode"].stringValue
        tmnCode = json["vnp_TmnCode"].stringValue
        transactionNo = json["vnp_TransactionNo"].stringValue
        transactionStatus = json["vnp_TransactionStatus"].stringValue
        txnRef = json["vnp_TxnRef"].stringValue
        secureHash = json["vnp_SecureHash"].stringValue
    }
}

// MARK: - Public

extension VNPaymentResultRequestModel {
    func toDict() -> [String: Any] {
        return [
            "vnp_Amount": amount,
            "vnp_BankCode": bankCode,
            "vnp_BankTranNo": bankTransactionNo,
            "vnp_CardType": cardType,
            "vnp_OrderInfo": orderInfo,
            "vnp_PayDate": paymentDate,
            "vnp_ResponseCode": responseCode,
            "vnp_TmnCode": tmnCode,
            "vnp_TransactionNo": transactionNo,
            "vnp_TransactionStatus": transactionStatus,
            "vnp_TxnRef": txnRef,
            "vnp_SecureHash": secureHash
        ]
    }
}
