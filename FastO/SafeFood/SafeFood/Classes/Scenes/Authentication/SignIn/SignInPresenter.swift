import Foundation
import SVProgressHUD
import AppAuth
import FBSDKLoginKit

final class SignInPresenter: SignInViewOutput {

    typealias PostRegistrationCallback = (_ configuration: OIDServiceConfiguration?, _ registrationResponse: OIDRegistrationResponse?) -> Void

    // MARK: - Private Variable

    private struct Constants {
        static let accountIsInactive = "INACTIVE"
    }

    private let defaultsStorage: DefaultsStorage = DefaultsStorageImpl()
    private let notificationCenter: NotificationCenterService = NotificationCenter.default
    private var authState: OIDAuthState?

    // MARK: - Public Variable

    weak var view: SignInViewInput?

    func loginByEmail(with validator: SignInValidator) {
        if let error = validateSignInByEmailInput(with: validator) {
            ToastHelper.showError(error)
            return
        }

        view?.startLoading()
        AuthenService.shared.loginByEmail(validator.email, password: validator.password) { [weak self] result in
            guard let self = self else { return }
            self.view?.finishLoading()
            switch result {
            case .success:
                guard let status = self.defaultsStorage.status else { return }
                if status == Constants.accountIsInactive {

                    ToastHelper.showToast(R.string.localizable.digit_code_inactive.localized() + validator.email)
                    self.view?.showDigitVerifyCodePopup(email: validator.email, type: .login)
                } else {
                    self.notificationCenter.post(name: AccountNotifications.authorizationCompleted, object: nil)
                }
            case let .failure(error):
                self.view?.showError(error.message)
            }
        }
    }

    func loginByFaceBook() {
        if let accessToken = AccessToken.current, !accessToken.isExpired {
            loginByFaceBook(accessToken.tokenString)
        } else {
            let loginWithFB = LoginManager()
            loginWithFB.logIn(permissions: ["email"], from: view?.viewController) { [weak self] result, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                guard let result = result, !result.isCancelled else {
                    SVProgressHUD.showError(withStatus: "User canceled login")
                    SVProgressHUD.dismiss(withDelay: 1.5)
                    return
                }

                guard let self = self,
                      let accessToken = AccessToken.current, !accessToken.isExpired else {
                    print("Access token is expired")
                    return
                }
                self.loginByFaceBook(accessToken.tokenString)
            }
        }
    }

    func loginByGoogle() {
        guard let issuer = URL(string: GoogleAppAuth.kIssuer) else {
            print("Error creating URL for : \(GoogleAppAuth.kIssuer)")
            return
        }

        // MARK: Discovers Endpoints

        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { [weak self] configuration, error in

            guard let self = self,
                  let config = configuration else {
                print("Error retrieving discovery document: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
//                self?.setAuthState(nil)
                return
            }

            if let clientId = GoogleAppAuth.kClientID {
                self.doAuthWithAutoCodeExchange(configuration: config,
                                                clientID: clientId,
                                                clientSecret: nil)
            } else {
                self.doClientRegistration(configuration: config) { configuration, response in

                    guard let configuration = configuration, let clientID = response?.clientID else {
                        print("Error retrieving configuration OR clientID")
                        return
                    }

                    self.doAuthWithAutoCodeExchange(configuration: configuration,
                                                    clientID: clientID,
                                                    clientSecret: response?.clientSecret)
                }
            }
        }
    }
}

// MARK: - Private

private extension SignInPresenter {

    func validateSignInByEmailInput(with validator: SignInValidator) -> String? {
        guard validator.isValidEmail() else {
            return R.string.localizable.sign_in_email_error.localized()
        }

        guard validator.isValidPassword() else {
            return R.string.localizable.sign_in_password_error.localized()
        }

        return nil
    }

    func loginByFaceBook(_ accessToken: String) {
        AuthenService.shared.loginByFaceBook(accessToken) { [weak self] result in
            switch result {
            case .success:
                self?.notificationCenter.post(name: AccountNotifications.authorizationCompleted, object: nil)

            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.message)
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }

    func loginByGoogle(_ accessToken: String) {
        AuthenService.shared.loginByGoogle(accessToken) { [weak self] result in
            switch result {
            case .success:
                self?.notificationCenter.post(name: AccountNotifications.authorizationCompleted, object: nil)

            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.message)
                SVProgressHUD.dismiss(withDelay: 1.5)
            }
        }
    }
}

// MARK: - Login with Google

private extension SignInPresenter {
    func setAuthState(_ authState: OIDAuthState?) {
        if self.authState == authState {
            return
        }
        self.authState = authState
    }

    func doAuthWithAutoCodeExchange(
        configuration: OIDServiceConfiguration,
        clientID: String,
        clientSecret: String?
    ) {

        guard let redirectURI = URL(string: GoogleAppAuth.kRedirectURI) else {
            print("Error creating URL for : \(GoogleAppAuth.kRedirectURI)")
            return
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let viewController = view?.viewController else {
            print("Error accessing AppDelegate")
            return
        }

        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID,
                                              clientSecret: clientSecret,
                                              scopes: [OIDScopeOpenID, OIDScopeProfile, OIDScopeEmail],
                                              redirectURL: redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)

        print("ABC: \(request)")
        appDelegate.googleAppAuthSession = OIDAuthState.authState(byPresenting: request, presenting: viewController) { [weak self] authState, error in

            guard let self = self,
                  let authState = authState else {
                print("Authorization error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
                SVProgressHUD.showError(withStatus: "User canceled login")
                SVProgressHUD.dismiss(withDelay: 1.5)
//                self?.setAuthState(nil)
                return
            }

            self.setAuthState(authState)

            if let accessToken = authState.lastTokenResponse?.accessToken {
                self.loginByGoogle(accessToken)
            }
        }
    }

    func doClientRegistration(
        configuration: OIDServiceConfiguration,
        callback: @escaping PostRegistrationCallback
    ) {

        guard let redirectURI = URL(string: GoogleAppAuth.kRedirectURI) else {
            print("Error creating URL for : \(GoogleAppAuth.kRedirectURI)")
            return
        }

        let request: OIDRegistrationRequest = OIDRegistrationRequest(
            configuration: configuration,
            redirectURIs: [redirectURI],
            responseTypes: nil,
            grantTypes: nil,
            subjectType: nil,
            tokenEndpointAuthMethod: "client_secret_post",
            additionalParameters: nil
        )

        OIDAuthorizationService.perform(request) { [weak self] response, error in
            guard let self = self,
                  let regResponse = response else {
                print("Registration error: \(error?.localizedDescription ?? "DEFAULT_ERROR")")
//                self?.setAuthState(nil)
                return
            }

            self.setAuthState(OIDAuthState(registrationResponse: regResponse))
            callback(configuration, regResponse)
        }
    }
}
