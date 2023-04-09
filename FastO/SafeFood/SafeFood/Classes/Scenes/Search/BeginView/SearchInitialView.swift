import UIKit
import CoreLocation

final class SearchInitialView: NibView {

    struct Constants {
        static let heightHeader: CGFloat = 44
        static let rowSection: Int = 1
    }

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: BaseTableView!

    // MARK: - Private Variable

    private lazy var presenter: SearchInitialPresenter = {
        let presenter = SearchInitialPresenter()
        presenter.view = self
        return presenter
    }()
    
    // MARK: - Lifecycle

    override func configureView() {
        super.configureView()
        setupUI()
    }
}

// MARK: - Private

private extension SearchInitialView {
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchHeaderView.self)

        tableView.register(SearchNearLocationCell.self)
        tableView.register(SearchHotVoucherCell.self)
    }
}

// MARK: - Public

extension SearchInitialView {
    func setupData(_ latitude: Double, _ longitude: Double) {
        presenter.onViewDidLoad(latitude, longitude)
    }
}

// MARK: - UITableViewDataSource

extension SearchInitialView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SearchInitialSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SearchInitialSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .hotVoucher:
            return Constants.rowSection
        case .nearLocation:
            return  presenter.brands.isEmpty ? 0 : Constants.rowSection
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = SearchInitialSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch sectionType {
        case .nearLocation:
            let cell = tableView.dequeue(SearchNearLocationCell.self, for: indexPath)
            cell.brands = presenter.brands
            return cell
        case .hotVoucher:
            let cell = tableView.dequeue(SearchHotVoucherCell.self, for: indexPath)
            cell.hotVouchers = presenter.hotVouchers
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchInitialView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = SearchInitialSection(rawValue: section) else { return nil }

        let header = tableView.dequeue(SearchHeaderView.self)
        switch sectionType {
        case .hotVoucher:
            header.setupUI(title: sectionType.titleHeader, isSeeAll: false)
        case .nearLocation:
            header.setupUI(title: sectionType.titleHeader, isSeeAll: true)
            header.sectionType = .none
            header.nearBrands = presenter.brands
        }

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = SearchInitialSection(rawValue: section) else { return .leastNormalMagnitude }
        switch sectionType {
        case .hotVoucher:
            return Constants.heightHeader
        case .nearLocation:
            return presenter.brands.isEmpty ? .leastNormalMagnitude : Constants.heightHeader
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - SearchInitialViewInput

extension SearchInitialView: SearchInitialViewInput {
    func reloadTableViewData() {
        tableView.reloadData()
    }
}
