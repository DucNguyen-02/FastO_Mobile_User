import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool, scrollPosition: UITableView.ScrollPosition = UITableView.ScrollPosition.bottom) {
        let sectionsCount = numberOfSections
        if sectionsCount > 0 {
            let lastSection = sectionsCount - 1
            let rowsCount = numberOfRows(inSection: lastSection)
            if rowsCount != NSNotFound && rowsCount > 0 {
                let indexPath = IndexPath(row: rowsCount - 1, section: lastSection)
                scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
            }
        }
    }
    
    func distanceToBottom() -> CGFloat {
        return bottomOffset().y - contentOffset.y
    }
    
    func bottomOffset() -> CGPoint {
        let contentSizeHeight = contentSize.height
        let frameHeight = frame.size.height
        let bottomInset = contentInset.bottom
        let topInset = contentInset.top
        let offset = CGPoint(x: 0, y: max(-topInset, contentSizeHeight - (frameHeight - bottomInset)))
        return offset
    }
    
    func indexPathForViewInHierarchy(_ view: UIView) -> IndexPath? {
        let viewPoint = view.convert(CGPoint.zero, to: self)
        return indexPathForRow(at: viewPoint)
    }
    
    func reloadData(_ completion: @escaping () -> Void ) {
        UIView.animate(withDuration: 0) {
            self.reloadData()
        } completion: { _ in
            completion()
        }
    }
}
