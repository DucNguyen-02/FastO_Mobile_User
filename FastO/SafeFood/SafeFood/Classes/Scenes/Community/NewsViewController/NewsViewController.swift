//
//  NewsViewController.swift
//  AppPass
//
//  Created by Lê Kim Hoàng on 10/3/22.
//  
//

import UIKit

final class NewsViewController: BaseViewController {

    struct Constants {
        static let designItemSize = CGSize(width: 375, height: 266)
        static let designScreenWidth: CGFloat = 375
        static var itemSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = screenWidth / designScreenWidth
            let itemWidth = designItemSize.width * ratio
            let itemHeight = designItemSize.height * ratio
            return CGSize(width: itemWidth, height: itemHeight)
        }()
    }

    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: BaseTableView!

    // MARK: - Private Variable
    
    private lazy var presenter: NewsPresenter = {
      let presenter = NewsPresenter()
      presenter.view = self
      return presenter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        setupUI()
    }
}

// MARK: - Private

private extension NewsViewController {
    func setupUI() {
        tableView.register(NewsCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NewsCell.self)
        cell.setupData(news: presenter.news[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let topVC = UIViewController.topViewController() {
            let vc = DetailNewsViewController.makeMe()
            vc.setupData(id: presenter.news[indexPath.row].id)
            topVC.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.itemSize.height
    }
}

// MARK: - NewsViewInput

extension NewsViewController: NewsViewInput {
    func reloadTableViewData() {
        tableView.reloadData()
    }
}
