import UIKit

final class HomeTopChartCommunityCell: UITableViewCell {
    
    // MARK: - IBOutlet

    @IBOutlet private weak var numberView: UIView!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberView.roundCorners(.topLeft, radius: 5)
    }
}

// MARK: - Public

extension HomeTopChartCommunityCell {
    func setupData(index: Int, community: HomeCommunityModel) {
        titleLabel.text = community.title
        contentLabel.text = community.content
        numberLabel.text = "\(index + 1)"
    }
}
