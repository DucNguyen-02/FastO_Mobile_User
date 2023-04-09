//
//  RatingPresenter.swift
//  AppPass
//
//  Created by Zipris on 25/11/2022.
//  
//

import Foundation

final class RatingPresenter {
    
    // MARK: - Public Variable
    
    weak var view: RatingViewInput?
}

// MARK: - RatingViewOutput

extension RatingPresenter: RatingViewOutput {
    func onViewDidLoad(review: [String: Any]) {
        postRating(review: review)
    }
}

// MARK: - Private

private extension RatingPresenter {
    func postRating(review: [String: Any]) {
        RatingService.shared.postRating(review) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.view?.dismissView()
                
            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }
}
