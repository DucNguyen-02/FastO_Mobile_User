import Foundation

final class ManagerPresenter {
    
    // MARK: - Public Variable
    
    weak var view: ManagerViewInput?
}

// MARK: - ManagerViewOutput

extension ManagerPresenter: ManagerViewOutput {
    func onViewDidLoad() {
        
    }
}
