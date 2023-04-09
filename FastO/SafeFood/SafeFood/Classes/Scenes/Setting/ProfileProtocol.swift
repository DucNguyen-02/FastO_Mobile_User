//
//  ProfileProtocol.swift
//  SafeFood
//
//  Created by ADMIN on 21/11/2022.
//

import UIKit

protocol ProfileViewInput: AnyObject {
    func reloadData()
    func reloadAvatar()
}

protocol ProfileViewOutput: AnyObject {
    func onViewDidLoad()
    func onUpdate(_ info: [String: Any])
    func onUploadImage(images: [UIImage])
}
