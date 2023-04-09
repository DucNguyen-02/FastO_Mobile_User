//
//  ListBrandApplyVoucherViewProtocol.swift
//  SafeFood
//
//  Created by Zipris on 28/11/2022.
//  
//

import Foundation

protocol ListBrandApplyVoucherViewInput: AnyObject {
    func reloadCollectionViewData()
}

protocol ListBrandApplyVoucherViewOutput: AnyObject {
    func onViewDidLoad()
}
