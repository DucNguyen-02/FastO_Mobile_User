//
//  DetailNewsViewController.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/20/22.
//  
//

import UIKit
import WebKit

final class DetailNewsViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var webView: WKWebView!

    // MARK: - Private Variable
    
    private lazy var presenter: DetailNewsPresenter = {
      let presenter = DetailNewsPresenter()
      presenter.view = self
      return presenter
    }()

    // MARK: - IBAction

    @IBAction private func backButtonTapped(_ sender: Any) {
        popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Public

extension DetailNewsViewController {
    func setupData(id: Int) {

        presenter.onViewDidLoad(id: id)
    }
}

// MARK: - DetailNewViewInput

extension DetailNewsViewController: DetailNewsViewInput {
    func updateUI(news: HomeNewsModel) {
        webView.loadHTMLString(news.content, baseURL: nil)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
    }
}
