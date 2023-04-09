//
//  NewsViewProtocol.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/3/22.
//  
//

import Foundation

protocol NewsViewInput: AnyObject {
    func reloadTableViewData()
}

protocol NewsViewOutput: AnyObject {
    func onViewDidLoad()
}
