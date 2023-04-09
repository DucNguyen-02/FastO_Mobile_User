//
//  ManagerPresenter.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/14/22.
//  
//

import Foundation

final class ManagerPresenter {
    
    // MARK: - Public Variable
    
    weak var view: ManagerViewInput?
}

// MARK: - ManagerViewOutput

extension ManagerPresenter: ManagerViewOutput {
    func onViewDidLoad() {
        
    }
}
