//
//  DetailNewPresenter.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/20/22.
//  
//

import Foundation
import SVProgressHUD

final class DetailNewsPresenter {
    
    // MARK: - Public Variable
    
    weak var view: DetailNewsViewInput?
    var news: HomeNewsModel?
}

// MARK: - DetailNewViewOutput

extension DetailNewsPresenter: DetailNewsViewOutput {
    func onViewDidLoad(id: Int) {
        getDeatilNews(id: id)
    }
}

// MARK: - Private

private extension DetailNewsPresenter {
    func getDeatilNews(id: Int) {
        NewsService.shared.getDetailNews(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(news):
                self.view?.updateUI(news: news)

            case let .failure(error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
}
