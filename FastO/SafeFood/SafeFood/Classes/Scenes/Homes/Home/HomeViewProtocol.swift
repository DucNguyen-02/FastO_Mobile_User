import Foundation

protocol HomeViewInput: AnyObject, CanNavigateViewControllers {
    func reloadTableViewData()
}

protocol HomeViewOutput: AnyObject {
    func onViewDidLoad()
}

protocol HomeRecentKeywordDelegate: AnyObject {
    func removeKeyword(keyword: String)
    func addKeyword(keyword: String)
}

protocol HomeNewsDelegate: AnyObject {
    func detailNews(id: Int)
}
