//
//  DetailVoucherViewProtocol.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/16/22.
//  
//

import Foundation

protocol DetailVoucherViewInput: AnyObject {
    func reloadData()
}

protocol DetailVoucherViewOutput: AnyObject {
    func onViewDidLoad(id: Int)
}
