import UIKit
import STPopup

final class ForgotPasswordViewController: BaseViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var localizedEmailLabel: UILabel!
    @IBOutlet private weak var localizedGuideLabel: UILabel!
    @IBOutlet private weak var emailTextField: BaseTextField!
    @IBOutlet private weak var sendButton: BaseButton!

    // MARK: - Private Variable

    private var verifyCodeViewController: STPopupController!
    private lazy var presenter: ForgotPasswordPresenter = {
        let presenter = ForgotPasswordPresenter()
        presenter.view = self
        return presenter
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func applyLocalization() {
        title = R.string.localizable.forget_password.localized()
        localizedEmailLabel.text = R.string.localizable.sign_up_email.localized()
        emailTextField.placeholder = R.string.localizable.sign_up_enter_your_email.localized()
        localizedGuideLabel.text = R.string.localizable.forget_password_guide.localized()
        sendButton.setTitle(R.string.localizable.forget_password_send_button.localized(), for: .normal)
    }

    // MARK: - IBAction
    
    @IBAction private func sendButtonTapped(_ sender: Any) {
        let email = emailTextField.text.orEmpty.cleanUpWhitespaces()
        configErrorTextFieldIfNeeded(email)
        presenter.forgotPasswordByEmail(email)
    }
}

// MARK: - Private

private extension ForgotPasswordViewController {
    func setupUI() {
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)
        setupTextField()
    }

    func setupTextField() {
        emailTextField.delegate = self
        emailTextField.clearButtonMode = .whileEditing
        if let clearPasswordButton = emailTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearPasswordButton.setImage(R.image.icClose(), for: .normal)
        }
    }

    func showVerifyCodePopup() {
        let email = emailTextField.text.orEmpty.cleanUpWhitespaces()

        let vc = DigitVerifyCodeViewController.makeMe()
        vc.setupData(email, type: .forgotPassword)
        vc.type = .forgotPassword
        vc.forgotPassworddelegate = self
        vc.contentSizeInPopup = DigitVerifyCodeViewController.Constants.viewSize
        verifyCodeViewController = setupSTPopup(vc: vc)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundVerifyCodeView))
        verifyCodeViewController.backgroundView?.addGestureRecognizer(tapGesture)
    }

    @objc func didTapBackgroundVerifyCodeView() {
        verifyCodeViewController.dismiss()
    }


    func configErrorTextFieldIfNeeded(_ email: String) {
        emailTextField.borderColor = email.isEmail() ? R.color.grayA2A2A3() : R.color.redFF2929()
    }
}

// MARK: - UITextFieldDelegate

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()

        return true
    }
}

// MARK: - ForgotPasswordDelegate

extension ForgotPasswordViewController: ForgotPasswordDelegate {
    func resetPassword(authToken: String) {
        let vc = ResetPasswordViewController.makeMe()
        vc.setupData(authToken: authToken)
        pushViewController(vc, animated: true)
    }
}

// MARK: - ForgotPasswordViewInput

extension ForgotPasswordViewController: ForgotPasswordViewInput {
    func showDigitVerifyCodePopup() {
        showVerifyCodePopup()
    }
}
