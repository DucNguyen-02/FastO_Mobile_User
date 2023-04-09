//
//  MenuBrandViewProtocol.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/18/22.
//  
//

import Foundation

protocol MenuBrandViewInput: AnyObject {
    func reloadTableViewData()
}

protocol MenuBrandViewOutput: AnyObject {
    func onViewDidLoad(shopId: Int)
}

protocol MenuBrandDelegate: AnyObject {
    func totalProduct(number: Int, productId: Int, quantity: Int, price: Int)
    func totalDetailProduct(productId: Int, changeQuantity: Int, quantity: Int, price: Int)
}
