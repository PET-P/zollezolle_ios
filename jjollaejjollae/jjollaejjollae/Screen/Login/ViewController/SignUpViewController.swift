//
//  SignInViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/07.
//

import UIKit

class SignUpViewController: UIViewController, StoryboardInstantiable {
  //MARK: - IBOUTLET
  @IBOutlet weak var topSignUpLabel: UILabel! {
    didSet {
      topSignUpLabel.titleStyle(text: "처음이시군요!")
    }
  }
  @IBOutlet weak var middleSignUpLabel: UILabel! {
    didSet {
      middleSignUpLabel.titleStyle(text: "비밀번호를")
    }
  }
  @IBOutlet weak var bottomSignUpLabel: UILabel! {
    didSet {
      bottomSignUpLabel.titleStyle(text: "설정해 주세요")
    }
  }
  @IBOutlet weak var passwordTextField: UITextField! {
    didSet {
      passwordTextField.addLeftPadding()
    }
  }
  @IBOutlet weak var passwordStyleErrorLabel: UILabel! {
    didSet {
      passwordStyleErrorLabel.text = "형식에 맞는 비밀번호를 입력해주세요"
      passwordStyleErrorLabel.textColor = UIColor.errorColor
      passwordStyleErrorLabel.font = UIFont.robotoMedium(size: 14)
      passwordStyleErrorLabel.alpha = 0
    }
  }
  
  @IBOutlet weak var confirmationTextField: UITextField! {
    didSet {
      confirmationTextField.addLeftPadding()
    }
  }
  @IBOutlet weak var confirmationStyleErrorLabel: UILabel! {
    didSet {
      confirmationStyleErrorLabel.text = "비밀번호와 동일하지 않습니다"
      confirmationStyleErrorLabel.textColor = UIColor.errorColor
      confirmationStyleErrorLabel.font = UIFont.robotoMedium(size: 14)
      confirmationStyleErrorLabel.alpha = 0
    }
  }
  
  @IBOutlet weak var SignUpContinueButton: UIButton! {
    didSet {
      SignUpContinueButton.setTitle("계속하기", for: .normal)
      SignUpContinueButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      SignUpContinueButton.titleLabel?.textColor = UIColor.white
      SignUpContinueButton.tintColor = UIColor.white
      SignUpContinueButton.setRounded(radius: 25)
      SignUpContinueButton.backgroundColor = UIColor.themeGreen
    }
  }
  
  @IBOutlet var stackView: UIStackView!
  @IBOutlet var scrollView: UIScrollView!
  
  //MARK: - 변수
  var containerWidth: CGFloat = 0.0
  
  private var passwordStyleErrorText: String = "" {
    didSet {
      passwordStyleErrorLabel.text = "\(passwordStyleErrorText)"
    }
  }
  private var confirmationErrorText: String = "" {
    didSet {
      if confirmationErrorText == "초록으로 변하기" {
        confirmationStyleErrorLabel.alpha = 0
      } else {
        if confirmationErrorText == "일치합니다" {
          confirmationStyleErrorLabel.textColor = .themePaleGreen
        } else {
          confirmationStyleErrorLabel.textColor = .errorColor
        }
        confirmationStyleErrorLabel.alpha = 1
      }
      confirmationStyleErrorLabel.text = confirmationErrorText
    }
  }
  
  private var signUpModel: SignUp = SignUp()
  
  internal func setEmail(email: String) {
    signUpModel.email = email
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    containerWidth = self.view.frame.size.width
    passwordTextField.underlineStyle(textColor: UIColor.gray03, borderColor: UIColor.themePaleGreen, width: containerWidth)
    confirmationTextField.underlineStyle(textColor: UIColor.gray03, borderColor: UIColor.themePaleGreen, width: containerWidth)
    confirmationTextField.addTarget(self, action: #selector(updateConfirmationUI(_:)), for: .editingChanged)
    setKeyboard()
    passwordTextField.addTarget(self, action: #selector(updatePasswordStyleErrorLabelUI(_:)), for: .editingChanged)
  }
  
  @IBAction private func didTapSignUpContinueButton(_ sender: UIButton) {
    // pop the controller
    signUpModel.password = passwordTextField.text ?? "imshipassword??"
    let additionalInfoStoryboard = UIStoryboard.init(name: "AdditionalInfo", bundle: nil)
    guard let additionalInfoVC = additionalInfoStoryboard.instantiateViewController(identifier: "AdditionalInfoViewController") as? AdditionalInfoViewController else {return}
    additionalInfoVC.setData(data: signUpModel)
    self.navigationController?.pushViewController(additionalInfoVC, animated: true)
  }
  
  @objc private func updateConfirmationUI(_ sender: Any?) {
    //비밀번호가 동일하지 않거나?? 저시기 머시기
    let isConfirmed = LoginManager.shared.isPasswordVerified(password: self.passwordTextField.text , confirmation: self.confirmationTextField.text)
    print(isConfirmed)
    let containerWidth = self.view.frame.size.width
    switch isConfirmed {
    case 0:
      confirmationErrorText = "비밀번호와 일치하지 않습니다"
      confirmationTextField.changeUnderLine(borderColor: .errorColor, width: containerWidth)
    case 1:
      confirmationErrorText = "일치합니다"
      confirmationTextField.changeUnderLine(borderColor: .themePaleGreen, width: containerWidth)
    case 2:
      confirmationErrorText = "비밀번호 입력란을 채워주세요"
      confirmationTextField.changeUnderLine(borderColor: .errorColor, width: containerWidth)
    default:
      confirmationErrorText = "초록으로 변하기"
      confirmationTextField.changeUnderLine(borderColor: .themePaleGreen, width: containerWidth)
    }
    
  }
  
  @IBAction private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func updatePasswordStyleErrorLabelUI(_ sender: Any?) {
    guard let passwordStr = passwordTextField.text else {return}
    if !LoginManager.shared.isValidPassword(password: passwordStr) {
      passwordStyleErrorLabel.alpha = 1
      passwordTextField.changeUnderLine(borderColor: .errorColor, width: self.view.frame.size.width)
      self.passwordStyleErrorText = "올바른 형식의 password를 입력해주세요"
    } else {
      passwordTextField.changeUnderLine(borderColor: .themePaleGreen, width: self.view.frame.size.width)
      passwordStyleErrorLabel.alpha = 0
    }
  }
}

extension SignUpViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.becomeFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
  private func setKeyboard() {
    passwordTextField.delegate = self
    confirmationTextField.delegate = self
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))
    view.addGestureRecognizer(tapGesture)
    
    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { (notification) in
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
      guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
      UIView.animate(withDuration: duration) {
        self.view.layoutIfNeeded()
      }
    }
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { (notification) in
      guard let userInfo = notification.userInfo else {
        return
      }
      let contentInset = UIEdgeInsets.zero
      self.scrollView.contentInset = contentInset
      self.scrollView.scrollIndicatorInsets = contentInset
      guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
      UIView.animate(withDuration: duration) {
        self.view.layoutIfNeeded()
      }
    }
  }
}


