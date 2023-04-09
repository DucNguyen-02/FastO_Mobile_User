//
//  RatingViewProtocol.swift
//  AppPass
//
//  Created by Zipris on 25/11/2022.
//  
//

import Foundation

protocol RatingViewInput: AnyObject {
    func dismissView()
}

protocol RatingViewOutput: AnyObject {
    func onViewDidLoad(review: [String: Any])
}
