import UIKit
import FSPagerView

protocol HomeNewDelegate: AnyObject {
    func clickDetailNews(id: Int)
}

final class HomeNewsView: NibView {
    
    struct Constants {
        static let pageControlHeight: CGFloat = 6
        static let spaceBetweenPageControlAndPagerView: CGFloat = 12
        static let spaceBetween2Items: CGFloat = 12
        static let designItemSize = CGSize(width: 260, height: 370)
        static let designScreenWidth: CGFloat = 375
        static var itemSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = screenWidth / designScreenWidth
            let itemWidth = designItemSize.width * ratio
            let itemHeight = designItemSize.height * ratio
            return CGSize(width: itemWidth, height: itemHeight)
        }()
        static var sectionHeight: CGFloat = {
            return itemSize.height + pageControlHeight + spaceBetweenPageControlAndPagerView
        }()
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var pagerView: FSPagerView!
    @IBOutlet private weak var pageControl: FSPageControl!
    
    // MARK: - Private Variable
    
    private(set) var currentIndex: Int = 0 {
        didSet {
            pageControl.currentPage = currentIndex
        }
    }
    
    // MARK: - Public Variable
    
    var listNews: [HomeNewsModel] = [] {
        didSet {
            pageControl.numberOfPages = listNews.count
            pagerView.reloadData()
        }
    }
    weak var homeNewsDelegate: HomeNewsDelegate?

    // MARK: - Lifecycle
    
    override func configureView() {
        super.configureView()
        setupUI()
    }
}

// MARK: - Private

private extension HomeNewsView {
    func setupUI() {
        pagerView.register(UINib(nibName: "HomeNewsCell", bundle: nil), forCellWithReuseIdentifier: "HomeNewsCell")
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 3
        pagerView.interitemSpacing = Constants.spaceBetween2Items
        pagerView.itemSize = Constants.itemSize
        pagerView.delegate = self
        pagerView.dataSource = self
        
        pageControl.itemSpacing = 8
        pageControl.interitemSpacing = 8
        pageControl.setFillColor(R.color.grayE8E8E8() ?? .lightGray, for: .normal)
        pageControl.setFillColor(R.color.gray454546() ?? .gray, for: .selected)
    }
}

// MARK: - FSPagerViewDataSource

extension HomeNewsView: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return listNews.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HomeNewsCell", at: index) as! HomeNewsCell
        cell.delegate = self
        cell.setupData(news: listNews[index])
        return cell
    }
}

// MARK: - FSPagerViewDelegate

extension HomeNewsView: FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        guard let newsCell = cell as? HomeNewsCell else { return }
        newsCell.cancelDownload()
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        currentIndex = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        currentIndex = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return false
    }
}

// MARK: - HomeNewsDelegate

extension HomeNewsView: HomeNewDelegate {
    func clickDetailNews(id: Int) {
        homeNewsDelegate?.detailNews(id: id)
    }
}
