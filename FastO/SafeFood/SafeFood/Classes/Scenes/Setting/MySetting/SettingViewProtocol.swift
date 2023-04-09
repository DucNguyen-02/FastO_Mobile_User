//
//  SettingViewProtocol.swift
//  SafeFood
//
//  Created by ADMIN on 21/11/2022.
//  
//

import UIKit

protocol SettingViewInput: AnyObject {
    func reloadData()
}

protocol SettingViewOutput: AnyObject {
    func onViewDidLoad()
    func onUploadImage(images: [UIImage])
}
