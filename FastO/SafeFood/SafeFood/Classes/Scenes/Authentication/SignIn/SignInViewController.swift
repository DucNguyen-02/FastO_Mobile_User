import UIKit
import TTTAttributedLabel
import STPopup

final class SignInViewController: BaseViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var localizedTitleLabel: UILabel!
    @IBOutlet private weak var localizedFacebookLabel: UILabel!
    @IBOutlet private weak var localizedGoogleLabel: UILabel!
    @IBOutlet private weak var localizedOrLabel: UILabel!

    @IBOutlet private weak var scrollView: BaseScrollView!
    @IBOutlet private weak var loopedVideoPlayerView: LoopedVideoPlayerView!
    @IBOutlet private weak var signInFacebookButton: BaseButton!
    @IBOutlet private weak var signInGoogleButton: BaseButton!
    @IBOutlet private weak var signUpEmailButton: BaseButton!
    @IBOutlet private weak var forgotPasswordButton: BaseButton!
    @IBOutlet private weak var loginButton: BaseButton!
    @IBOutlet private weak var hiddenPasswordButton: BaseButton!
    @IBOutlet private weak var experienceButton: BaseButton!
    @IBOutlet private weak var emailTextField: BaseTextField!
    @IBOutlet private weak var passwordTextField: BaseTextField!
    @IBOutlet private weak var passwordContainerView: UIStackView!
    @IBOutlet private weak var emailContainerView: UIStackView!

    // MARK: - Private Variable

    private var isHide: Bool = true
    private var verifyCodeViewController: STPopupController!
    private lazy var presenter: SignInPresenter = {
        let presenter = SignInPresenter()
        presenter.view = self
        return presenter
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loopedVideoPlayerView.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loopedVideoPlayerView.stop()
    }
    
    deinit {
        loopedVideoPlayerView.destroy()
    }

    override func applyLocalization() {
        localizedTitleLabel.text = R.string.localizable.sign_in_title.localized()
        localizedGoogleLabel.text = R.string.localizable.sign_in_google.localized()
        localizedFacebookLabel.text = R.string.localizable.sign_in_facebook.localized()
        localizedOrLabel.text = R.string.localizable.sign_in_or.localized()
        emailTextField.placeholder = R.string.localizable.sign_in_placehold_email.localized()
        passwordTextField.placeholder = R.string.localizable.sign_in_placehold_password.localized()
        loginButton.setTitle(R.string.localizable.login.localized(), for: .normal)
        experienceButton.setTitle(R.string.localizable.sign_in_experience.localized(), for: .normal)
        signUpEmailButton.setTitle(R.string.localizable.sign_in_need_a_count.localized(), for: .normal)
        forgotPasswordButton.setTitle(R.string.localizable.sign_in_forgot_password.localized(), for: .normal)
    }

    // MARK: - IBAction
    
    @IBAction private func hiddenPasswordButtonTapped(_ sender: Any) {
        hiddenPasswordButton.setImage(isHide ? R.image.ic_eye() : R.image.ic_eyeslash(), for: .normal)
        isHide.toggle()
        passwordTextField.isSecureTextEntry = isHide
    }

    @IBAction private func signInWithFacebookTapped(_ sender: Any) {
        presenter.loginByFaceBook()
    }

    @IBAction private func signInWithGoogleTapped(_ sender: Any) {
        presenter.loginByGoogle()
    }
    
    @IBAction private func forgotPasswordTapped(_ sender: Any) {
        let vc = ForgotPasswordViewController.makeMe()
        pushViewController(vc, animated: true)
    }

    @IBAction private func signUpTapped(_ sender: Any) {
        let vc = SignUpViewController.makeMe()
        pushViewController(vc, with: .fade)
    }

    @IBAction private func loginTapped(_ sender: Any) {
        let email = emailTextField.text.orEmpty.cleanUpWhitespaces()
        let password = passwordTextField.text.orEmpty.cleanUpWhitespaces()

        configErrorTextFieldIfNeeded(email, password)

        let validator = SignInValidator(email: email, password: password)
        presenter.loginByEmail(with: validator)
        if passwordTextField.text.orEmpty.isEmpty == true {
            passwordTextField.becomeFirstResponder()
        } else {
            emailTextField.becomeFirstResponder()
        }
    }
}

// MARK: - Private

private extension SignInViewController {
    func setupUI() {
        scrollView.contentInsetAdjustmentBehavior = .never
        setupTextField()

        if let loginVideoPath = Bundle.main.path(forResource: "vietnamese", ofType: "mp4") {
            loopedVideoPlayerView.prepareVideo(URL(fileURLWithPath: loginVideoPath))
        }
    }

    func setupTextField() {
        emailTextField.delegate = self
        emailTextField.clearButtonMode = .whileEditing
        if let clearEmailButton = emailTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearEmailButton.setImage(R.image.icClose(), for: .normal)
        }

        passwordTextField.delegate = self
        passwordTextField.clearButtonMode = .whileEditing
        if let clearPasswordButton = passwordTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearPasswordButton.setImage(R.image.icClose(), for: .normal)
        }
    }

    func configErrorTextFieldIfNeeded(_ email: String, _ password: String) {
        emailContainerView.borderColor = email.isEmail() ? R.color.grayA2A2A3() : R.color.redFF2929()
        passwordContainerView.borderColor = password.isNotEmpty ? R.color.grayA2A2A3() : R.color.redFF2929()
    }

    func showVerifyCodePopup(email: String, type: VerifyCodeType) {
        let email = emailTextField.text.orEmpty.cleanUpWhitespaces()
        let vc = DigitVerifyCodeViewController.makeMe()
        vc.setupData(email, type: type)
        vc.contentSizeInPopup = DigitVerifyCodeViewController.Constants.viewSize
        verifyCodeViewController = setupSTPopup(vc: vc)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundVerifyCodeView))
        verifyCodeViewController.backgroundView?.addGestureRecognizer(tapGesture)
    }

    @objc func didTapBackgroundVerifyCodeView() {
        verifyCodeViewController.dismiss()
    }
}

// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
    }
}

// MARK: - SignInOptionViewInput

extension SignInViewController: SignInViewInput {
    var viewController: UIViewController {
        return self
    }

    func showDigitVerifyCodePopup(email: String, type: VerifyCodeType) {
        showVerifyCodePopup(email: email, type: type)
    }
}
