//
//  ShopCommunityViewProtocol.swift
//  SafeFood
//
//  Created by Zipris on 24/11/2022.
//  
//

import Foundation

protocol ShopCommunityViewInput: AnyObject {
    func reloadCollectionViewData()
}

protocol ShopCommunityViewOutput: AnyObject {
    func onViewDidLoad()
}
