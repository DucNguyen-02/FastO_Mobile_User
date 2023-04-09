import UIKit

final class ResetPasswordViewController: BaseViewController {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var localizedNewPasswordLabel: UILabel!
    @IBOutlet private weak var localizedConfirmPasswordLabel: UILabel!
    @IBOutlet private weak var localizedGuideLabel: UILabel!
    @IBOutlet private weak var newPasswordView: UIStackView!
    @IBOutlet private weak var confirmPasswordView: UIStackView!
    @IBOutlet private weak var newPasswordTextField: BaseTextField!
    @IBOutlet private weak var confirmPasswordTextField: BaseTextField!
    @IBOutlet private weak var hiddenNewPasswordButton: BaseButton!
    @IBOutlet private weak var hiddenConfirmPasswordButton: BaseButton!
    @IBOutlet private weak var sendButton: BaseButton!

    // MARK: - Private Variable

    private var isHide: Bool = true
    private var authToken: String = ""
    private lazy var presenter: ResetPasswordPresenter = {
        let presenter = ResetPasswordPresenter()
        presenter.view = self
        return presenter
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func applyLocalization() {
        title = R.string.localizable.reset_password.localized()
        localizedNewPasswordLabel.text = R.string.localizable.reset_password_new_password.localized()
        newPasswordTextField.placeholder = R.string.localizable.sign_up_enter_your_password.localized()
        localizedGuideLabel.text = R.string.localizable.reset_password_guide.localized()
        localizedConfirmPasswordLabel.text = R.string.localizable.sign_up_confirm_password.localized()
        confirmPasswordTextField.placeholder = R.string.localizable.sign_up_re_enter_password.localized()
        sendButton.setTitle(R.string.localizable.digit_code_verify.localized(), for: .normal)
    }

    // MARK: - IBAction

    @IBAction private func hiddenPasswordButtonTapped(_ sender: Any) {
        hiddenNewPasswordButton.setImage(isHide ? R.image.ic_eye() : R.image.ic_eyeslash(), for: .normal)
        hiddenConfirmPasswordButton.setImage(isHide ? R.image.ic_eye() : R.image.ic_eyeslash(), for: .normal)
        
        isHide.toggle()

        newPasswordTextField.isSecureTextEntry = isHide
        confirmPasswordTextField.isSecureTextEntry = isHide
    }
    
    @IBAction private  func sendButtonTapped(_ sender: Any) {
        let password = newPasswordTextField.text.orEmpty.cleanUpWhitespaces()
        let confirmPassword = confirmPasswordTextField.text.orEmpty.cleanUpWhitespaces()

        configErrorTextFieldIfNeeded(password, confirmPassword)
        let resetPasswordValidator = ResetPasswordValidator(password: password, confirmPassword: confirmPassword)
        presenter.onResetPasswordButtonTapped(authToken: authToken, with: resetPasswordValidator)
    }
}

private extension ResetPasswordViewController {
    func setupUI() {
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)
        setupTextField()
    }

    func setupTextField() {
        newPasswordTextField.delegate = self
        newPasswordTextField.clearButtonMode = .whileEditing
        if let clearPasswordButton = newPasswordTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearPasswordButton.setImage(R.image.icClose(), for: .normal)
        }

        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.clearButtonMode = .whileEditing
        if let clearPasswordButton = confirmPasswordTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearPasswordButton.setImage(R.image.icClose(), for: .normal)
        }
    }


    func configErrorTextFieldIfNeeded(_ password: String, _ confirmPassword: String) {
        newPasswordView.borderColor = password.isNotEmpty ? R.color.grayA2A2A3() : R.color.redFF2929()
        confirmPasswordView.borderColor = password.isNotEmpty && password == confirmPassword ? R.color.grayA2A2A3() : R.color.redFF2929()
    }
}

// MARK: - Public

extension ResetPasswordViewController {
    func setupData(authToken: String) {
        self.authToken = authToken
    }
}

// MARK: - UITextFieldDelegate

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()

        return true
    }
}

// MARK: - ResetPasswordViewInput

extension ResetPasswordViewController: ResetPasswordViewInput {}
