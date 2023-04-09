//
//  DetailBrandReviewView.swift
//  SafeFood
//
//  Created by Zipris on 28/11/2022.
//

import UIKit

final class DetailBrandReviewView: NibView {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: BaseTableView!
    
    // MARK: - Private Variable
    
    private var reviews: [ReviewModel] = []
    
    // MARK: - Lifecycle
    
    override func configureView() {
        super.configureView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailBrandReviewCell.self)
    }
}

// MARK: - Public

extension DetailBrandReviewView {
    func setupData(reviews: [ReviewModel]) {
        self.reviews = reviews
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension DetailBrandReviewView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count > 3 ? 3 : reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DetailBrandReviewCell.self)
        cell.setupData(review: reviews[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DetailBrandReviewView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
