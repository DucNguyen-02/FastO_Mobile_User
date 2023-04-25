import Foundation
import SwiftyJSON

// MARK: - PaymentServiceProtocol

protocol PaymentServiceProtocol {
    func vnPayMethod(requestModel: VNPaymentRequestModel, completion: @escaping ServiceRequestCompletion<String>)
    func getVNPaymentResult(requestModel: VNPaymentResultRequestModel, completion: @escaping ServiceRequestCompletion<VNPaymentReturnModel>)
}

// MARK: - PaymentService

final class PaymentService: PaymentServiceProtocol {
    
    // MARK: - Private
    
    private var networkAdapter: NetworkAdapter = NetworkAdapterImpl()
    
    static let shared = PaymentService()
    
    func vnPayMethod(
        requestModel: VNPaymentRequestModel,
        completion: @escaping ServiceRequestCompletion<String>
    ) {
        networkAdapter.request(target: PaymentRouter.vnPayMethod(requestModel: requestModel)) { result in
            switch result {
                
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJSON = JSON(data)
                    let url = dataJSON["url"].stringValue
                    completion(.success(url))
                } catch {
                    completion(.failure(.mappingError()))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getVNPaymentResult(
        requestModel: VNPaymentResultRequestModel,
        completion: @escaping ServiceRequestCompletion<VNPaymentReturnModel>
    ) {
        
        networkAdapter.request(target: PaymentRouter.getVNPayResult(requestModel: requestModel)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let dataJson = JSON(data)
                    let paymentReturn = VNPaymentReturnModel(json: dataJson)
                    completion(.success(paymentReturn))
                } catch {
                    completion(.failure(.mappingError()))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
