//
//  HomeRecentBrandProtocol.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/18/22.
//

import Foundation

protocol HomeRecentBrandViewInput: AnyObject {
}

protocol HomeRecentBrandViewOutput: AnyObject {
    func onViewDidLoad(id: Int)
}
