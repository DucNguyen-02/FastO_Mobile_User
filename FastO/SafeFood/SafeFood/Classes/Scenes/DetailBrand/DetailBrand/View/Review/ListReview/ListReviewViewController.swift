//
//  ListReviewViewController.swift
//  SafeFood
//
//  Created by Zipris on 28/11/2022.
//

import UIKit

final class ListReviewViewController: BaseViewController {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: BaseTableView!
    
    // MARK: - Private Variable
    
    private var reviews: [ReviewModel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)
        title = "Review"
        
        setupUI()
    }
}

// MARK: - Public

extension ListReviewViewController {
    func setupData(reviews: [ReviewModel]) {
        self.reviews = reviews
    }
}

// MARK: - Private

private extension ListReviewViewController {
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailBrandReviewCell.self)
    }
}

// MARK: - UITableViewDataSource

extension ListReviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DetailBrandReviewCell.self)
        cell.setupData(review: reviews[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
