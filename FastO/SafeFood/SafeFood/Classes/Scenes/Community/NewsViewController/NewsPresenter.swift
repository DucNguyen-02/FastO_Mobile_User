//
//  NewsPresenter.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/3/22.
//  
//

import Foundation
import SVProgressHUD

final class NewsPresenter {
    
    // MARK: - Public Variable

    var news: [HomeNewsModel] = []
    weak var view: NewsViewInput?
}

// MARK: - NewsViewOutput

extension NewsPresenter: NewsViewOutput {
    func onViewDidLoad() {
        getAllNews()
    }
}

// MARK: - Private

extension NewsPresenter {
    func getAllNews() {
        NewsService.shared.getHomeNews { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(news):
                self.news = news
                self.view?.reloadTableViewData()

            case let .failure(error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
}
