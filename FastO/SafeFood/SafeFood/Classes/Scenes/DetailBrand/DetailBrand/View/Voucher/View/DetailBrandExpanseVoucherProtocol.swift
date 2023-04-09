//
//  DetailBrandExpanseVoucherProtocol.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/17/22.
//

import Foundation

protocol DetailBrandExpanseVoucherViewInput: AnyObject {
    func reloadData()
}

protocol DetailBrandExpanseVoucherViewOutput: AnyObject {
    func onViewDidLoad(with brandId: Int)
}
