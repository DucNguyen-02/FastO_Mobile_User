//
//  DetailNewViewProtocol.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/20/22.
//  
//

import Foundation

protocol DetailNewsViewInput: AnyObject {
    func updateUI(news: HomeNewsModel)
}

protocol DetailNewsViewOutput: AnyObject {
    func onViewDidLoad(id: Int)
}
