//
//  PasswordViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/06.
//

import UIKit

class PasswordViewController: UIViewController, StoryboardInstantiable {
  
  var loginData: LoginData?
  private var email: String = ""
  
  func setEmail(email: String) {
    self.email = email
  }
    
  @IBOutlet weak var topPasswordLabel: UILabel! {
    didSet {
      topPasswordLabel.text = "비밀번호를"
      topPasswordLabel.font = UIFont.robotoBold(size: 30)
      topPasswordLabel.textColor = UIColor.gray01
    }
  }
  @IBOutlet weak var bottomPasswordLabel: UILabel! {
    didSet {
      bottomPasswordLabel.text = "입력해주세요"
      bottomPasswordLabel.font = UIFont.robotoBold(size: 30)
      bottomPasswordLabel.textColor = UIColor.gray01
    }
  }
  @IBOutlet weak var passwordTextField: UITextField! {
    didSet {
      passwordTextField.addLeftPadding()
    }
  }
  @IBOutlet weak var LoginButton: UIButton! {
    didSet {
      LoginButton.setTitle("로그인", for: .normal)
      LoginButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      LoginButton.titleLabel?.textColor = UIColor.white
      LoginButton.tintColor = UIColor.white
      LoginButton.setRounded(radius: 25)
      LoginButton.backgroundColor = UIColor.themeGreen
    }
  }
  @IBOutlet weak var passwordErrorLabel: UILabel! {
    didSet {
      passwordErrorLabel.alpha = 0
      passwordErrorLabel.textColor = UIColor.errorColor
      passwordErrorLabel.font = UIFont.robotoMedium(size: 14)
      passwordErrorLabel.text = "잘못된 비밀번호 입니다."
    }
  }
  @IBOutlet weak var findPasswordButton: UIButton! {
    didSet {
      findPasswordButton.isHidden = true
      findPasswordButton.underLine(buttonString: "비밀번호를 잊으셨나요?")
    }
  }
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!

  
  private var passwordErrorText: String = "" {
    didSet {
      passwordErrorLabel.text = "\(passwordErrorText)"
      if passwordErrorText == "잘못된 비밀번호입니다." {
        passwordErrorLabel.alpha = 1
      } else {
        passwordErrorLabel.alpha = 0
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    passwordTextField.underlineStyle(
      textColor: UIColor.gray03,
      borderColor: UIColor.themePaleGreen, width: self.view.frame.width)
    setKeyboard()
    passwordTextField.addTarget(self, action: #selector(updatedPasswordTextfieldUI(_:)),
                             for: .editingChanged)
  }
  
  
  @objc private func updatedPasswordTextfieldUI(_ sender: Any?) {
    if passwordErrorText == "잘못된 비밀번호입니다." {
      passwordTextField.changeUnderLine(borderColor: UIColor.themePaleGreen, width: self.view.frame.width)
      passwordErrorText = ""
    }
  }
  
  @IBAction private func didTapLoginButton(_ sender: UIButton) {
    APIService.shared.login(email, passwordTextField.text ?? "") { [self] result in
      switch result {
      case .success(let data):
        loginData = data
        // 서버 통신해서 성공했다면 즉시 앱에 token 저장
        // keychain에 저장하자
        if let loginData = loginData {
          LoginManager.shared.saveInKeychain(account: "accessToken", value: loginData.accessToken)
          LoginManager.shared.saveInKeychain(account: "refreshToken", value: loginData.refreshToken)
          self.navigationController?.pushViewController(MainTabBarController(), animated: true)
        }
        
      case .failure(let error):
        print(error)
        if error >= 400 && error < 500 {
          passwordTextField.changeUnderLine(borderColor: UIColor.errorColor, width: self.view.frame.width)
          passwordErrorText = "잘못된 비밀번호입니다."
          findPasswordButton.isHidden = false
        }
      }
    }
  }
  //
  @IBAction private func didTapFindPasswordButton(_ sender: UIButton) {
    guard let findPasswordVC = FindPasswordViewController.loadFromStoryboard() as? FindPasswordViewController else {return}
    findPasswordVC.setEmail(email: self.email)
    self.navigationController?.pushViewController(findPasswordVC, animated: true)
  }
  
  @IBAction private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}

extension PasswordViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.becomeFirstResponder()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
  private func setKeyboard() {
    passwordTextField.delegate = self
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))
    view.addGestureRecognizer(tapGesture)
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                           object: nil,
                                           queue: OperationQueue.main) { (notification) in
      guard let userInfo = notification.userInfo else { return }
      guard let keyboardFrame =
        userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        
      let contentInset = UIEdgeInsets(
        top: 0.0,
        left: 0.0,
        bottom: keyboardFrame.size.height,
        right: 0.0
      )
      self.scrollView.contentInset = contentInset
      self.scrollView.scrollIndicatorInsets = contentInset
      guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
              as? TimeInterval else {return}
      UIView.animate(withDuration: duration) {
        self.view.layoutIfNeeded()
      }
    }
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                           object: nil,
                                           queue: OperationQueue.main) { (notification) in
      guard let userInfo = notification.userInfo else { return }
      let contentInset = UIEdgeInsets.zero
      self.scrollView.contentInset = contentInset
      self.scrollView.scrollIndicatorInsets = contentInset
      guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
              as? TimeInterval else {return}
      UIView.animate(withDuration: duration) {
        self.view.layoutIfNeeded()
      }
    }
  }
}
