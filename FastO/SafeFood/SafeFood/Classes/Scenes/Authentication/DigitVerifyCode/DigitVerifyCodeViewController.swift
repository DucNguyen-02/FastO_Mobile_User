import UIKit

final class DigitVerifyCodeViewController: BaseViewController {

    struct Constants {
        static let designViewSize = CGSize(width: 375, height: 350)
        static let designScreenWidth: CGFloat = 375
        static var viewSize: CGSize = {
            let screenWidth = UIScreen.main.bounds.width
            let ratio = screenWidth / designScreenWidth
            let viewWidth = designViewSize.width * ratio
            let viewHeight = designViewSize.height * ratio
            return CGSize(width: viewWidth, height: viewHeight)
        }()
    }
    
    // MARK: - IBOutlet

    @IBOutlet private weak var localizedNameScreenLabel: UILabel!
    @IBOutlet private weak var localizedGuideLabel: UILabel!
    @IBOutlet private weak var countDownLabel: UILabel!
    @IBOutlet private weak var codeTextField: BaseTextField!
    @IBOutlet private weak var resendButton: BaseButton!
    @IBOutlet private weak var confirmButton: BaseButton!

    // MARK: - Private Variable

    private let maxNumberOfVerificationCode = 6
    private var email: String = ""
    private var isResend: Bool = true
    private var time: Int = 60
    private var isActiveAccount: Bool = false
    private lazy var presenter: DigitVerifyCodePresenter = {
        let presenter = DigitVerifyCodePresenter()
        presenter.view = self
        return presenter
    }()

    // MARK: - Public Variable

    weak var forgotPassworddelegate: ForgotPasswordDelegate?
    var type: VerifyCodeType = .signUp

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func applyLocalization() {
        localizedNameScreenLabel.text = R.string.localizable.digit_code.localized()
        localizedGuideLabel.text = R.string.localizable.digit_code_guide.localized()
        resendButton.setTitle(R.string.localizable.digit_code_resend_code.localized(), for: .normal)
        confirmButton.setTitle(R.string.localizable.digit_code_verify.localized(), for: .normal)
    }

    // MARK: - IBAction

    @IBAction private func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction private func resendCodeTapped(_ sender: Any) {
        codeTextField.text?.removeAll()
        time = 60
        isResend.toggle()
        isActiveAccount ? presenter.resendDigitCodeActive(email) : presenter.resendCodeForgotPassword(email)
    }

    @IBAction private func confirmButtonTapped(_ sender: Any) {
        let code = codeTextField.text.orEmpty.cleanUpWhitespaces()
        switch type {
        case .forgotPassword:
            presenter.digitCodeForgotPassword(code)
        case .signUp, .login:
            presenter.digitCodeActive(code)
        }
    }
}

// MARK: - Private

private extension DigitVerifyCodeViewController {
    func setupUI() {
        setupCountDown()
        setupTextField()
        disableVerifyButton()
    }

    func setupTextField() {
        codeTextField.delegate = self
        codeTextField.addTarget(self, action: #selector(codeInputTextFieldDidChanged), for: .editingChanged)
    }

    @objc func codeInputTextFieldDidChanged(_ textField: UITextField) {
        guard let inputCount = textField.text?.count else { return }
        inputCount < maxNumberOfVerificationCode ? disableVerifyButton() : enableVerifyButton()
    }

    @objc func countDown() {
        if time > 0 {
            countDownLabel.text = "0:" + String(format: "%02d", time - 1)
            time -= 1
            resendButton.isHidden = true
        } else {
            resendButton.isHidden = false
        }
    }

    func setupCountDown() {
        resendButton.isHidden = true
        if isResend {
            isResend.toggle()
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        }
    }

    func enableVerifyButton() {
        confirmButton.backgroundColor = R.color.blue4789FA()
        confirmButton.isUserInteractionEnabled = true
    }

    func disableVerifyButton() {
        confirmButton.backgroundColor = R.color.grayA2A2A3()
        confirmButton.isUserInteractionEnabled = false
    }
}

// MARK: - Public

extension DigitVerifyCodeViewController {
    func setupData(_ email: String, type: VerifyCodeType) {
        self.email = email
        switch type {
        case .signUp:
            self.isActiveAccount = true

        case .login:
            self.isActiveAccount = true
            presenter.resendDigitCodeActive(email)

        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate

extension DigitVerifyCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        codeTextField.resignFirstResponder()
        return true
    }
}


// MARK: - DigitVerifyCodeViewInput

extension DigitVerifyCodeViewController: DigitVerifyCodeViewInput {
    func dismiss(isForgotPassword: Bool,_ authToken: String?) {
        isForgotPassword ? forgotPassworddelegate?.resetPassword(authToken: authToken.orEmpty) : nil
        dismiss(animated: true)
    }

}
