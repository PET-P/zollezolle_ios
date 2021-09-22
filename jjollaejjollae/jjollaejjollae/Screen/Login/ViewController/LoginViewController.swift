//
//  LoginViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/04.
//

import UIKit

class LoginViewController: UIViewController {
  
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
      bottomLoginTitle.font = UIFont.robotoBold(size: 30)
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
      naverLoginButton.setTitle("네이버 로그인", for: .normal)
      naverLoginButton.roundedButton(cornerRadius: 25)
      naverLoginButton.backgroundColor = UIColor(rgb: 0x75D15D)
      naverLoginButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      naverLoginButton.tintColor = UIColor.white
      naverLoginButton.titleLabel?.textColor = UIColor.white
    }
  }
  @IBOutlet weak var kakaoLoginButton: UIButton! {
    didSet {
      kakaoLoginButton.setTitle("카카오 로그인", for: .normal)
      kakaoLoginButton.setRounded(radius: 25)
      kakaoLoginButton.backgroundColor = UIColor(rgb: 0xFFE841)
      kakaoLoginButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      kakaoLoginButton.tintColor = UIColor.black
      kakaoLoginButton.titleLabel?.textColor = UIColor.black
    }
  }
  @IBOutlet weak var appleLoginButton: UIButton! {
    didSet {
      appleLoginButton.setTitle("애플 로그인", for: .normal)
      appleLoginButton.setRounded(radius: 25)
      appleLoginButton.backgroundColor = UIColor.black
      appleLoginButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      appleLoginButton.tintColor = UIColor.white
      appleLoginButton.titleLabel?.textColor = UIColor.white
    }
  }
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
  
  private let loginManager = LoginManager()
  
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
    
  }
  @IBAction private func didTapKakaoLoginButton(_ sender: UIButton) {
    
  }
  @IBAction private func didTapAppleLoginButton(_ sender: UIButton) {
    
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
