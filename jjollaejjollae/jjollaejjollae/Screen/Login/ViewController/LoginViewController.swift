//
//  LoginViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/04.
//

import UIKit
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import Alamofire

@available(iOS 13.0, *)

class LoginViewController: UIViewController, NaverThirdPartyLoginConnectionDelegate{
  
  private var naverUser: SocialUser?
  private var completionHandler: (() -> Void)?
 
  @IBOutlet weak var emailTextField: UITextField! {
    didSet {
      emailTextField.addLeftPadding()
    }
  }
  @IBOutlet weak var topLoginTitle: UILabel! {
    didSet {
      topLoginTitle.text = "반려동물과"
      topLoginTitle.font = UIFont.robotoBold(size: 30)
      topLoginTitle.textColor = UIColor.gray01
    }
  }
  @IBOutlet weak var bottomLoginTitle: UILabel! {
    didSet {
      bottomLoginTitle.text = "여행을 떠나 볼까요?"
//      bottomLoginTitle.font = UIFont.robotoBold(size: 30)
      bottomLoginTitle.textColor = UIColor.gray01
    }
  }
  @IBOutlet weak var continueButton: UIButton! {
    didSet {
      continueButton.isEnabled = false
      continueButton.setTitle("계속하기", for: .normal)
      continueButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      continueButton.titleLabel?.textColor = UIColor.white
      continueButton.tintColor = UIColor.white
      continueButton.setRounded(radius: 25)
      continueButton.backgroundColor = UIColor.themeGreen.withAlphaComponent(0.5)
    }
  }
  @IBOutlet weak var goToHomeButton: UIButton! {
    didSet {
      goToHomeButton.setTitle("맞춤정보 없이 둘러보기", for: .normal)
      goToHomeButton.titleLabel?.font = UIFont.robotoBold(size: 16)
      goToHomeButton.titleLabel?.textColor = UIColor.gray04
      goToHomeButton.tintColor = UIColor.gray04
      goToHomeButton.backgroundColor = .none
      goToHomeButton.layer.borderWidth = 0
    }
  }
  @IBOutlet weak var naverLoginButton: UIButton! {
    didSet {
      naverLoginButton.roundedButton(cornerRadius: nil)
    }
  }
  @IBOutlet weak var kakaoLoginButton: UIButton! {
    didSet {
      kakaoLoginButton.setRounded(radius: nil)
    }
  }
  @IBOutlet weak var appleLoginButton: UIButton!
  @IBOutlet weak var provisionLabel: UILabel! {
    didSet {
      provisionLabel.numberOfLines = 1
      provisionLabel.font = UIFont.robotoRegular(size: 12)
      provisionLabel.textColor = .gray01
    }
  }
  @IBOutlet weak var provisionButton: UIButton! {
    didSet {
      provisionButton.setTitleColor(.gray01, for: .normal)
      provisionButton.titleLabel?.font = .robotoBold(size: 12)
    }
  }
  @IBOutlet weak var lastProvisionLabel: UILabel! {
    didSet {
      lastProvisionLabel.numberOfLines = 1
      lastProvisionLabel.font = UIFont.robotoRegular(size: 12)
      lastProvisionLabel.textColor = .gray01
    }
  }
  @IBOutlet weak var errorLabel: UILabel! {
    didSet {
      errorLabel.text = "가입되지 않은 이메일입니다."
      errorLabel.textColor = UIColor.errorColor
      errorLabel.isHidden = true
      errorLabel.font = UIFont.robotoMedium(size: 14)
    }
  }
  
  private let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
  private let loginManager = LoginManager()
  private let dispatchGroup = DispatchGroup()
  
  private var errorText: String = "가입되지 않은 이메일입니다."{
    didSet {
      errorLabel.text = "\(errorText)"
    }
  }
  
  private var continueButtonColor: UIColor = .themeGreen.withAlphaComponent(0.5) {
    didSet {
      continueButton.backgroundColor = continueButtonColor
      if continueButtonColor == UIColor.themeGreen.withAlphaComponent(0.5) {
        continueButton.isEnabled = false
      } else {
        continueButton.isEnabled = true
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))
    view.addGestureRecognizer(tapGesture)
    emailTextField.underlineStyle(
      textColor: UIColor.gray03,
      borderColor: UIColor.themePaleGreen, width: self.view.frame.width)
    privacyLinkLabel()
    emailTextField.addTarget(self, action: #selector(updateEmailValidationUI(_:)),
                             for: .editingChanged)
    emailTextField.delegate = self
  }
  
  private func privacyLinkLabel() {
    
    let buttonAttributedStr = NSMutableAttributedString(string: provisionButton.currentTitle!)
    buttonAttributedStr.addAttributes([.kern: -0.5,
                                       .underlineStyle: NSUnderlineStyle.thick.rawValue,
                                       .underlineColor: UIColor.gray01],
                                      range: NSRange(location: 0,
                                                     length: buttonAttributedStr.length))
    
    let attributedStr = NSMutableAttributedString(string: provisionLabel.text!)
    let lastAttributedStr = NSMutableAttributedString(string: lastProvisionLabel.text!)
    lastAttributedStr.addAttribute(.kern, value: -0.5,
                                   range: NSRange(location: 0, length: lastAttributedStr.length))
    lastProvisionLabel.attributedText = lastAttributedStr
    attributedStr.addAttribute(.kern, value: -0.5,
                               range: NSRange(location: 0, length: attributedStr.length))
    provisionLabel.attributedText = attributedStr
    provisionButton.setAttributedTitle(buttonAttributedStr, for: .normal)
  }
  
  @IBAction private func didTapProvisionButton(_ sender: UIButton) {
    guard let provisionVC = storyboard?.instantiateViewController(
            identifier: "ProvisionViewController") as? ProvisionViewController else {
      return
    }
    provisionVC.modalPresentationStyle = .fullScreen
    self.present(provisionVC, animated: true, completion: nil);
  }
  
  @IBAction private func didTapContinueButton(_ sender: UIButton) {
    //버튼 글씨가 회원가입이면 signUpVC으로 간다.
    if sender.currentTitle == "회원가입" {
      let signUpStoryBoard = UIStoryboard.init(name: "SignUp", bundle: nil)
      guard let signUpVC = signUpStoryBoard.instantiateViewController(
              identifier: "SignUpViewController") as? SignUpViewController else {return}
      signUpVC.setEmail(email: self.emailTextField.text!)
      self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    //'계속하기'일 경우에는 이메일이 맞는지 확인해본다.
    APIService.shared.email(emailTextField.text ?? "") {
      [weak self] result in
      guard let self = self else {return}
      switch result  {
      case .success(_):
        let passwordStoryboard = UIStoryboard.init(name: "Password", bundle: nil)
        guard let passwordVC = passwordStoryboard.instantiateViewController(
                identifier: "PasswordViewController") as? PasswordViewController else {return}
        passwordVC.setEmail(email: self.emailTextField.text!)
        self.navigationController?.pushViewController(passwordVC, animated: true)
      case .failure(let error):
        if error >= 400 && error < 500 {
          self.errorText = "가입되지 않은 이메일입니다."
          self.continueButton.setTitle("회원가입", for: .normal)
        }
      }
    }
  }
  
  @IBAction private func didTapGotoHome(_ sender: UIButton) {
    let SearchStoryboard = UIStoryboard(name: "Search", bundle: nil)
    guard let searchVC = SearchStoryboard
            .instantiateViewController(identifier: "SearchViewController") as? SearchViewController
    else { return }
    self.navigationController?.pushViewController(searchVC, animated: true)
  }
  
  @IBAction private func didTapNaverLoginButton(_ sender: UIButton) {
    loginInstance?.delegate = self
    loginInstance?.requestThirdPartyLogin()
  }
  
  @IBAction private func didTapKakaoLoginButton(_ sender: UIButton) {
    // 토큰이 있어서 그냥 로그인할수 있는 경우?
    if AuthApi.hasToken() {
      UserApi.shared.accessTokenInfo { [weak self] (_ ,error) in
        if let error = error {
          if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
            print("로그인필요1")
            self?.kakaoLogin()
          }
          else {
            print("기타애러 \(error)")
          }
        } else {
          print("토큰 유효성 체크 성공")
        }
      }
    } else {
      print("토큰없어서 로그인 필요")
      self.kakaoLogin()
    }
    dispatchGroup.notify(queue: .main) { [weak self] in
      self?.kakaoUserInfo(completion: { email, nick, phone in
        APIService.shared.socialLogin(email: email, nick: nick, phone: phone) { [weak self] result in
          switch result {
          case .success(let data):
            guard let accessToken = data.accessToken else {return}
            guard let refreshToken = data.refreshToken else {return}
            self?.loginManager.saveInKeychain(account: "accessToken", value: accessToken)
            self?.loginManager.saveInKeychain(account: "refreshToken", value: refreshToken)
          case .failure(let error):
            print(error)
          }
        }
      })
      self?.navigationController?.pushViewController(MainTabBarController(), animated: true)
    }
  }
  
  @IBAction private func didTapAppleLoginButton(_ sender: UIButton) {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
}

extension LoginViewController: UITextFieldDelegate {
  internal func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.becomeFirstResponder()
  }
  
  internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    self.view.endEditing(true)
  }
}

extension LoginViewController {
  //MARK: - updateUI Methods
  @objc private func updateEmailValidationUI(_ sender: Any?){
    guard let emailStr = self.emailTextField.text else {return}
    if !loginManager.isValidEmail(email: emailStr) {
      errorLabel.isHidden = false
      emailTextField.changeUnderLine(borderColor: .errorColor, width: self.view.frame.size.width)
      continueButtonColor = .themeGreen.withAlphaComponent(0.5)
      self.errorText = "올바른 형식의 email이 아닙니다."
    } else {
      emailTextField.changeUnderLine(borderColor: .themePaleGreen, width: self.view.frame.size.width)
      continueButtonColor = .themeGreen
      self.errorText = ""
    }
    if continueButton.currentTitle == "회원가입" {
      continueButton.setTitle("계속하기", for: .normal)
    }
  }
}

//MARK: - Social Login 설정

extension LoginViewController: StoryboardInstantiable {
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("[Success] : Success Naver Login")
    getNaverInfo()
    self.navigationController?.pushViewController(MainTabBarController(), animated: true)
  }
  
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    print("이미 로그인되어있다")
    getNaverInfo()
    self.navigationController?.pushViewController(MainTabBarController(), animated: true)
  }
  
  func oauth20ConnectionDidFinishDeleteToken() {
    print("delete")
  }
  
  // error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
    print("Error : ", error.localizedDescription)
  }
  
  private func getNaverInfo() {
    guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else {return}
    if !isValidAccessToken {
      return
    }
    guard let tokenType = loginInstance?.tokenType else {return}
    guard let accessToken = loginInstance?.accessToken else {return}
    let urlStr = "https://openapi.naver.com/v1/nid/me"
    let url = URL(string: urlStr)!
    let authorization = "\(tokenType) \(accessToken)"
  
    let req = AF.request(url, method: .get, parameters: nil,
                         encoding: JSONEncoding.default,
                         headers: ["Authorization": authorization])
    
    dispatchGroup.enter()
    req.responseJSON { [weak self] response in
      guard let result = response.value as? [String: Any] else {return}
      guard let object = result["response"] as? [String: Any] else { return }
      guard let _email = object["email"] as? String else { return }
      guard let _nickname = object["nickname"] as? String else { return }
      guard let _mobile = object["mobile"] as? String else { return }
      
      let socialUser = SocialUser(email: _email, nick: _nickname, phone: _mobile)
      self?.naverUser = socialUser
      self?.dispatchGroup.leave()
    }
    
    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let self = self else {
        return}
      guard let naverUser = self.naverUser else {
        return}
      APIService.shared.socialLogin(email: naverUser.email,
                                    nick: naverUser.nick,
                                    phone: naverUser.phone) { [weak self] (result) in
        switch result {
        case .success(let data):
          guard let accessToken = data.accessToken else {return}
          guard let refreshToken = data.refreshToken else {return}
          self?.loginManager.saveInKeychain(account: "accessToken", value: accessToken)
          self?.loginManager.saveInKeychain(account: "refreshToken", value: refreshToken)
        case .failure(let error):
          print(error)
        }
      }
    }
  }
  
  //MARK: - KAKAO SOCIAL LOGIN
  
  private func kakaoLogin() {
    //로그인?
    if UserApi.isKakaoTalkLoginAvailable() {
      // 카카오톡이 있는 경우
      dispatchGroup.enter()
      UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
        if let error = error {
          print(error)
        }
        else {
          print("loginwithKakaoTalk() success.")
          self?.dispatchGroup.leave()
          _ = oauthToken
        }
      }
    } else {
      // 카카오톡이 없는 경우
      dispatchGroup.enter()
      UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
        if let error = error {
          print(error)
        }
        else {
          print("loginWithKakaoTalk() success")
          self?.dispatchGroup.leave()
          _ = oauthToken
        }
      }
    }
  }
  
  private func kakaoUserInfo(completion: @escaping (String, String, String) -> Void) {
    
    var email: String = ""
    var nick: String = ""
    dispatchGroup.enter()
    UserApi.shared.me { [weak self] (user, error) in
      if let error = error {
        print("kakaoUserINfoERROR")
        return
      }
      else {
        print("me() success.")
        guard let _email = user?.kakaoAccount?.email else { return }
        guard let _nick = user?.properties?["nickname"] else { return }
        email = _email
        nick = _nick
        self?.dispatchGroup.leave()
      }
      self?.dispatchGroup.notify(queue: .main) {
        completion(email, nick, "")
      }
    }
  }
}


//MARK: - Apple Social Login

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
  
  //애플 로그인 성공
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    dispatchGroup.enter()
    guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {return}
    let ID = appleIDCredential.user
    let givenName = appleIDCredential.fullName?.givenName ?? ""
    let familyName = appleIDCredential.fullName?.familyName ?? ""
    var nick = givenName + familyName
    nick = nick == "" ? "쫄래" : nick
    dispatchGroup.leave()
    
    // 로그인이 되서 관련 정보를 받아왔다면 블록풀어주고 우리서버와 통신시작
    dispatchGroup.notify(queue: .main) {
      APIService.shared.socialLogin(email: ID, nick: nick, phone: "") { [weak self] (result) in
        switch result {
        case .success(let data):
          guard let accessToken = data.accessToken else {return}
          guard let refreshToken = data.refreshToken else {return}
          self?.loginManager.saveInKeychain(account: "accessToken", value: accessToken)
          self?.loginManager.saveInKeychain(account: "refreshToken", value: refreshToken)
        case .failure(let error):
          print(error)
        }
      }
    }
  }
  
  //로그인 실패
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("Apple login failed")
  }
}
