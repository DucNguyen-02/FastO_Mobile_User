//
//  CreateCommunityViewProtocol.swift
//  SafeFood
//
//  Created by Zipris on 23/11/2022.
//  
//

import UIKit

enum ScreenCommunityType: Int, CaseIterable {
    case new = 0
    case update
}

protocol CreateCommunityDelegate: AnyObject {
    func removeImage(image: String)
    func chooseShop(brand: BrandModel)
}

protocol CreateCommunityViewInput: AnyObject {
    func reloadCollectionViewData()
    func reloadData()
    func popViewController()
}

protocol CreateCommunityViewOutput: AnyObject {
    func onViewDidLoad(_ review: [String: Any], id: Int?, type: ScreenCommunityType)
    func onUploadImage(images: [UIImage])
    func onGetDetailCommunity(id: Int)
}
