import UIKit
import TTTAttributedLabel
import STPopup

final class SignUpViewController: BaseViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var localizedFirstNameLabel: UILabel!
    @IBOutlet private weak var localizedLastNameLabel: UILabel!
    @IBOutlet private weak var localizedBirthdayLabel: UILabel!
    @IBOutlet private weak var localizedEmailLabel: UILabel!
    @IBOutlet private weak var localizedPhoneLabel: UILabel!
    @IBOutlet private weak var localizedPasswordLabel: UILabel!
    @IBOutlet private weak var localizedGuidePasswordLabel: UILabel!
    @IBOutlet private weak var localizedConfirmPasswordLabel: UILabel!
    @IBOutlet private weak var termsAndPolicyLabel: TermsAndPolicyLabel!
    @IBOutlet private weak var signInLabel: SignInLabel!

    @IBOutlet private weak var firstNameTextField: BaseTextField!
    @IBOutlet private weak var lastNameTextField: BaseTextField!
    @IBOutlet private weak var birthdayTextField: BaseTextField!
    @IBOutlet private weak var emailTextField: BaseTextField!
    @IBOutlet private weak var phoneTextField: BaseTextField!
    @IBOutlet private weak var passwordTextField: BaseTextField!
    @IBOutlet private weak var confirmPasswordTextField: BaseTextField!

    @IBOutlet private weak var chooseBirthdayButton: BaseButton!
    @IBOutlet private weak var hiddenPasswordButton: BaseButton!
    @IBOutlet private weak var hiddenConfirmPasswordButton: BaseButton!
    @IBOutlet private weak var termAndPolicyButton: BaseButton!
    @IBOutlet private weak var signUpButton: BaseButton!

    // MARK: - Private Variable

    private var datePickerViewController: STPopupController!
    private var verifyCodeViewController: STPopupController!

    private var birthdayTimeInterval: TimeInterval?
    private var isHide: Bool = true
    private var isAcceptTerm: Bool = false

    private lazy var presenter: SignUpPresenter = {
        let presenter = SignUpPresenter()
        presenter.view = self
        return presenter
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func applyLocalization() {
        title = R.string.localizable.create_account.localized()
        localizedFirstNameLabel.text = R.string.localizable.sign_up_first_name.localized()
        localizedLastNameLabel.text = R.string.localizable.sign_up_last_name.localized()
        localizedBirthdayLabel.text = R.string.localizable.sign_up_birthday.localized()
        localizedEmailLabel.text = R.string.localizable.sign_up_email.localized()
        emailTextField.placeholder = R.string.localizable.sign_up_enter_your_email.localized()
        localizedPhoneLabel.text = R.string.localizable.sign_up_phone.localized()
        localizedPasswordLabel.text = R.string.localizable.sign_up_password.localized()
        passwordTextField.placeholder = R.string.localizable.sign_up_enter_your_password.localized()
        localizedGuidePasswordLabel.text = R.string.localizable.sign_up_password_convention.localized()
        localizedConfirmPasswordLabel.text = R.string.localizable.sign_up_confirm_password.localized()
        confirmPasswordTextField.placeholder = R.string.localizable.sign_up_re_enter_password.localized()
        signUpButton.setTitle(R.string.localizable.sign_up.localized(), for: .normal)
    }

    // MARK: - IBAction

    @IBAction private func hiddenPasswordButtonTapped(_ sender: Any) {
        hiddenPasswordButton.setImage(isHide ? R.image.ic_eye() : R.image.ic_eyeslash(), for: .normal)
        hiddenConfirmPasswordButton.setImage(isHide ? R.image.ic_eye() : R.image.ic_eyeslash(), for: .normal)

        isHide.toggle()
        passwordTextField.isSecureTextEntry = isHide
        confirmPasswordTextField.isSecureTextEntry = isHide
    }

    @IBAction private func chooseBirthdayButtonTapped(_ sender: Any) {
        showDatePickerPopup()
    }

    @IBAction private func termsAndPolicyButtonTapped(_ sender: Any) {
        isAcceptTerm.toggle()
        let image = isAcceptTerm ? R.image.authenticationCheckmark() : R.image.authenticationCheckmarkEmpty()
        termAndPolicyButton.setImage(image, for: .normal)
    }

    @IBAction private func signUpButtonTapped(_ sender: Any) {
        let firstName = firstNameTextField.text.orEmpty
        let lastName = lastNameTextField.text.orEmpty
        let birthday = birthdayTimeInterval ?? 0
        let phone = phoneTextField.text.orEmpty.cleanUpWhitespaces()
        let email = emailTextField.text.orEmpty.cleanUpWhitespaces()
        let password = passwordTextField.text.orEmpty.cleanUpWhitespaces()
        let repeatPassword = confirmPasswordTextField.text.orEmpty.cleanUpWhitespaces()

        let signUpValidator = SignUpValidator(firstName: firstName,
                                              lastName: lastName,
                                              dateOfBirth: birthday,
                                              phone: phone,
                                              email: email,
                                              password: password,
                                              repeatPassword: repeatPassword,
                                              isAcceptTermAndPolicy: isAcceptTerm)

        presenter.onSignUpButtonTapped(with: signUpValidator)
    }
    
}

// MARK: - Private

extension SignUpViewController {
    func setupUI() {
        hasNavigationBar = true
        navigationController?.addCustomBottomLine(color: R.color.grayA2A2A3() ?? .gray, height: 0.5)

        setupTextField()
        signInLabel.delegate = self
    }

    func setupTextField() {
        setupClearTextField(textField: firstNameTextField)
        setupClearTextField(textField: lastNameTextField)
        setupClearTextField(textField: birthdayTextField)
        setupClearTextField(textField: emailTextField)
        setupClearTextField(textField: phoneTextField)
        setupClearTextField(textField: passwordTextField)
        setupClearTextField(textField: confirmPasswordTextField)
    }

    func setupClearTextField(textField: UITextField) {
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        if let clearPasswordButton = textField.value(forKeyPath: "_clearButton") as? UIButton {
            clearPasswordButton.setImage(R.image.icClose(), for: .normal)
        }
    }

    func showDatePickerPopup() {
        let vc = DatePickerViewController()
        vc.delegate = self
        vc.contentSizeInPopup = DatePickerViewController.Constants.viewSize

        datePickerViewController = setupSTPopup(vc: vc)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        datePickerViewController.backgroundView?.addGestureRecognizer(tapGesture)
    }

    @objc func didTapBackgroundView() {
        datePickerViewController.dismiss()
    }

    func showVerifyCodePopup() {
        let email = emailTextField.text.orEmpty.cleanUpWhitespaces()
        let vc = DigitVerifyCodeViewController.makeMe()
        vc.setupData(email, type: .signUp)
        vc.contentSizeInPopup = DigitVerifyCodeViewController.Constants.viewSize
        verifyCodeViewController = setupSTPopup(vc: vc)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundVerifyCodeView))
        verifyCodeViewController.backgroundView?.addGestureRecognizer(tapGesture)
    }

    @objc func didTapBackgroundVerifyCodeView() {
        verifyCodeViewController.dismiss()
    }
}
// MARK: - TTTAttributedLabelDelegate

extension SignUpViewController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == SignInLabelURL.signInLinkAction {
            popViewController(with: .fade)
        }
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        birthdayTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()

        return true
    }
}

// MARK: - SignUpDelegate

extension SignUpViewController: SignUpDelegate {
    func chooseDate(date: Date) {
        self.birthdayTimeInterval = Date().timeIntervalSince(date)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.isoFullDate.formatString()
        let dateString = dateFormatter.string(from: date)
        birthdayTextField.text = dateString
    }
}

// MARK: - SignUpViewInput

extension SignUpViewController: SignUpViewInput {
    func digitVerifyCodePopup() {
        showVerifyCodePopup()
    }

    func successVerify() {
        
    }
}
