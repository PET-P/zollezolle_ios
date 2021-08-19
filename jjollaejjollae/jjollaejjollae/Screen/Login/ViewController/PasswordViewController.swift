//
//  PasswordViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/06.
//

import UIKit

class PasswordViewController: UIViewController {
  
  private lazy var loginManager = LoginManager()
    
  @IBOutlet weak var topPasswordLabel: UILabel! {
    didSet {
      topPasswordLabel.text = "비밀번호를"
      topPasswordLabel.font = UIFont.robotoBold(size: 30)
      topPasswordLabel.textColor = UIColor.쫄래블랙
    }
  }
  @IBOutlet weak var bottomPasswordLabel: UILabel! {
    didSet {
      bottomPasswordLabel.text = "입력해주세요"
      bottomPasswordLabel.font = UIFont.robotoBold(size: 30)
      bottomPasswordLabel.textColor = UIColor.쫄래블랙
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
      LoginButton.backgroundColor = UIColor.쫄래그린
    }
  }
  @IBOutlet weak var passwordErrorLabel: UILabel! {
    didSet {
      passwordErrorLabel.isHidden = true
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
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var stackView: UIStackView!

  
  private var passwordErrorText: String = "" {
    didSet {
      passwordErrorLabel.text = "\(passwordErrorText)"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    passwordTextField.underlineStyle(
      textColor: UIColor.회,
      borderColor: UIColor.쫄래페일그린, width: self.view.frame.width)
    setKeyboard()
  }
  
  @IBAction private func didTapLoginButton(_ sender: UIButton) {
      
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
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { (notification) in
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
      guard let userInfo = notification.userInfo else { return }
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
