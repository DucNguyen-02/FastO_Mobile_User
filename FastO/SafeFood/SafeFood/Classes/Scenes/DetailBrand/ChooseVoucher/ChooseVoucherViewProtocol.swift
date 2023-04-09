//
//  ChooseVoucherViewProtocol.swift
//  SafeFood
//
//  Created by ADMIN on 19/11/2022.
//  
//

import Foundation

protocol ChooseVoucherViewInput: AnyObject {
    func reloadTableViewData()
    func moveDetailOrder(billId: Int)
}

protocol ChooseVoucherViewOutput: AnyObject {
    func onViewDidLoad(_ params: [String: Any])
    func onCreateBill(_ params: [String: Any])
}
