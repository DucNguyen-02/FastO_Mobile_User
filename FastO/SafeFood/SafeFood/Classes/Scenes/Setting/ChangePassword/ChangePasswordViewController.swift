import UIKit

final class ChangePasswordViewController: BaseViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var oldLabel: UILabel!
    @IBOutlet private weak var newLabel: UILabel!
    @IBOutlet private weak var reNewLabel: UILabel!
    @IBOutlet private weak var oldTextField: BaseTextField!
    @IBOutlet private weak var newTextField: BaseTextField!
    @IBOutlet private weak var reNewTextField: BaseTextField!
    @IBOutlet private weak var hiddenOldPasswordButton: BaseButton!
    @IBOutlet private weak var hiddenNewPasswordButton: BaseButton!
    @IBOutlet private weak var hiddenConfirmPasswordButton: BaseButton!

    // MARK: - Private Variable

    private var isHide: Bool = false
    private lazy var presenter: ChangePasswordPresenter = {
        let presenter = ChangePasswordPresenter()
        presenter.view = self
        return presenter
    }()

    // MARK: - Public Variable


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)
        title = "Change Password"
    }

    // MARK: - IBAction
    
    @IBAction private func seePasswordButtonTapped(_ sender: Any) {
        hiddenNewPasswordButton.setImage(isHide ? R.image.ic_eye() : R.image.ic_eyeslash(), for: .normal)
        hiddenConfirmPasswordButton.setImage(isHide ? R.image.ic_eye() : R.image.ic_eyeslash(), for: .normal)
        hiddenOldPasswordButton.setImage(isHide ? R.image.ic_eye() : R.image.ic_eyeslash(), for: .normal)

        isHide.toggle()

        oldTextField.isSecureTextEntry = isHide
        newTextField.isSecureTextEntry = isHide
        reNewTextField.isSecureTextEntry = isHide
    }
    
    @IBAction private func confirmButtonTapped(_ sender: Any) {
        let oldPassword = oldTextField.text.orEmpty.cleanUpWhitespaces()
        let newPassword = newTextField.text.orEmpty.cleanUpWhitespaces()
        let confirmPassword = reNewTextField.text.orEmpty.cleanUpWhitespaces()
        configErrorTextFieldIfNeeded(oldPassword, newPassword, confirmPassword)

        guard let old = oldTextField.text,
              let new = newTextField.text,
              let reNew = reNewTextField.text else { return }

        let createParams = ChangePasswordModel(old: old, new: new, reNew: reNew)
        presenter.onDidViewLoad(createParams)
    }
}

// MARK: - Private

private extension ChangePasswordViewController {
    func setupTextField() {
        newTextField.delegate = self
        oldTextField.delegate = self
        reNewTextField.delegate = self

        newTextField.clearButtonMode = .whileEditing
        if let clearPasswordButton = newTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearPasswordButton.setImage(R.image.icClose(), for: .normal)
        }

        reNewTextField.clearButtonMode = .whileEditing
        if let clearPasswordButton = reNewTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearPasswordButton.setImage(R.image.icClose(), for: .normal)
        }

        oldTextField.clearButtonMode = .whileEditing
        if let clearPasswordButton = oldTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearPasswordButton.setImage(R.image.icClose(), for: .normal)
        }
    }


    func configErrorTextFieldIfNeeded(_ old: String, _ password: String, _ confirmPassword: String) {
        oldTextField.borderColor = old.isNotEmpty ? R.color.grayA2A2A3() : R.color.redFF2929()
        newTextField.borderColor = password.isNotEmpty ? R.color.grayA2A2A3() : R.color.redFF2929()
        reNewTextField.borderColor = password.isNotEmpty && password == confirmPassword ? R.color.grayA2A2A3() : R.color.redFF2929()
    }
}

// MARK: - UITextFieldDelegate

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        oldTextField.resignFirstResponder()
        newTextField.resignFirstResponder()
        reNewTextField.resignFirstResponder()

        return true
    }
}

// MARK: - ResetPasswordViewInput

extension ChangePasswordViewController: ChangePasswordViewInput {
    func successView() {
        oldTextField.text?.removeAll()
        newTextField.text?.removeAll()
        reNewTextField.text?.removeAll()
        oldTextField.resignFirstResponder()
        newTextField.resignFirstResponder()
        reNewTextField.resignFirstResponder()
        ToastHelper.showToast("Success Update password")
        popViewController(animated: true)
    }
}
