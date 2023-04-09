//
//  ChangePasswordModel.swift
//  SafeFood
//
//  Created by Lê Kim Hoàng on 11/11/22.
//

import Foundation

struct ChangePasswordModel {
    let old: String
    let new: String
    let reNew: String

    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["oldPassword"] = old
        dict["newPassword"] = new
        dict["confirmNewPassword"] = reNew

        return dict
    }
}

extension ChangePasswordModel {
    func isValidOldPassword() -> Bool {
        return old.isNotEmpty
    }

    func isValidPassword() -> Bool {
        return new.isNotEmpty
    }

    func isValidRepeatPassword() -> Bool {
        return reNew.isNotEmpty && new == reNew
    }
}
