//
//  ChangePasswordPresenter.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/7/22.
//

import Foundation

final class ChangePasswordPresenter: ChangePasswordViewOutput {

    // MARK: - Public Variable

    weak var view: ChangePasswordViewInput?

    func onDidViewLoad(_ change: ChangePasswordModel) {
        changePassword(change)
    }
}

// MARK: - Private

private extension ChangePasswordPresenter {
    func changePassword(_ change: ChangePasswordModel) {
        if let error = validateChangePasswordInput(with: change) {
            ToastHelper.showError(error)
            return
        }

        UserService.shared.changePassword(change.toDictionary()) { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view?.successView()

            case let .failure(error):
                ToastHelper.showError(error.message)
            }
        }
    }

    func validateChangePasswordInput(with validator: ChangePasswordModel) -> String? {
        guard validator.isValidPassword(),
              validator.isValidRepeatPassword()
        else {
            return R.string.localizable.sign_up_error.localized()
        }
        return nil
    }
}
