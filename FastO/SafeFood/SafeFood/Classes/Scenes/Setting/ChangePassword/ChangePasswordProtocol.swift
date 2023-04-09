//
//  ChangePasswordProtocol.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/7/22.
//

import Foundation

protocol ChangePasswordViewInput: AnyObject {
    func successView()
}

protocol ChangePasswordViewOutput: AnyObject {
    func onDidViewLoad(_ change: ChangePasswordModel)
}

