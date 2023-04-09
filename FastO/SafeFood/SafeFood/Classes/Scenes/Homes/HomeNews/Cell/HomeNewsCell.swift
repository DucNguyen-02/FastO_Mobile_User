import UIKit
import FSPagerView

final class HomeNewsCell: FSPagerViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var newsImageView: BaseImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var newsDescriptionLabel: UILabel!

    // MARK: - Private Variable

    private var news: HomeNewsModel?

    // MARK: - Public Variable

    weak var delegate: HomeNewDelegate?

    // MARK: - IBAction
    
    @IBAction private func ClickTapped(_ sender: Any) {
        if let news = news {
            delegate?.clickDetailNews(id: news.id)
        }
    }
}

// MARK: - Public

extension HomeNewsCell {
    func setupData(news: HomeNewsModel) {
        self.news = news
        newsTitleLabel.text = news.title
        newsDescriptionLabel.text = news.subTitle
        newsImageView.setImage(with: news.image, placeholderImage: nil)
    }
    
    func cancelDownload() {
        newsImageView.cancelDownloadTask()
    }
}
