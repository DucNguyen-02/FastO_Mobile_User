import Foundation
import FSPagerView

protocol SafeFoodBannerViewDelegate: AnyObject {
    func safeFoodBannerViewDidSelectItemAt(_ index: Int)
}

final class SafeFoodBannerView: NibView {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var pagerView: FSPagerView!
    @IBOutlet private weak var pageControl: UILabel!
    @IBOutlet private weak var pageControlView: UIView!
    
    // MARK: - Private Variable
    
    private var listImagesUrl: [String] = []
    
    private(set) var currentIndex: Int = 0 {
        didSet {
            updatePageControlIndex(pageControl, index: currentIndex)
        }
    }
    
    // MARK: - Public Variable
    
    var delegate: SafeFoodBannerViewDelegate?
    
    var pageControlBackGroundColor: UIColor? {
        didSet {
            pageControlView.backgroundColor = pageControlBackGroundColor
        }
    }
    
    // MARK: - Lifecycle
    
    override func configureView() {
        super.configureView()
        setupUI()
    }
}

// MARK: - Public

extension SafeFoodBannerView {
    func update(with imagesUrl: [String]) {
        listImagesUrl = imagesUrl
        currentIndex = 0
        pagerView.reloadData()
        pagerView.layoutIfNeeded()
    }
}
// MARK: - Private

private extension SafeFoodBannerView {
    func setupUI() {
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 3
    }
    
    func updatePageControlIndex(_ pageControl: UILabel, index: Int) {
        pageControl.text = "\(index + 1)/\(listImagesUrl.count)"
    }
}

// MARK: - FSPagerViewDataSource

extension SafeFoodBannerView: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return listImagesUrl.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        cell.imageView?.contentMode = .scaleAspectFill
        let url = URL(string: listImagesUrl[index])
        cell.imageView?.kf.setImage(with: url, placeholder: R.image.icPlaceholderImg())
        return cell
    }
}

// MARK: - FSPagerViewDelegate

extension SafeFoodBannerView: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        currentIndex = index
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int) {
        cell.imageView?.kf.cancelDownloadTask()
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        currentIndex = targetIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: false)
        delegate?.safeFoodBannerViewDidSelectItemAt(index)
    }
}
