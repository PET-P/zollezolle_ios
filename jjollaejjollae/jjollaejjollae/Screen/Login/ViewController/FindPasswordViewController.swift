//
//  FindPasswordViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/08.
//

import UIKit

class FindPasswordViewController: UIViewController {
  
  //MARK: - IBOUTLET
  @IBOutlet weak var findPasswordTopLabel: UILabel! {
    didSet {
      findPasswordTopLabel.titleStyle(text: "비밀번호 찾기")
    }
  }
  @IBOutlet weak var findPasswordBottomLabel: UILabel!{
    didSet {
      findPasswordBottomLabel.titleStyle(text: "잉")
      findPasswordBottomLabel.alpha = 0
    }
  }
  @IBOutlet weak var findEmailTextField: UITextField! {
    didSet {
      findEmailTextField.addLeftPadding()
    }
  }
  @IBOutlet weak var codeTextField: UITextField! {
    didSet {
      codeTextField.addLeftPadding()
    }
  }
  @IBOutlet var stackView: UIStackView!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var goToLoginButton: UIButton! {
    didSet {
      goToLoginButton.setTitle("로그인", for: .normal)
      goToLoginButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      goToLoginButton.titleLabel?.textColor = UIColor.white
      goToLoginButton.tintColor = UIColor.white
      goToLoginButton.setRounded(radius: 25)
      goToLoginButton.backgroundColor = UIColor.쫄래그린
    }
  }
  
  private lazy var SendCodeBUtton: UIButton = {
    let button = UIButton(type: .custom)
    let spacing: CGFloat = 15.0
    button.roundedButton(cornerRadius: 14)
    button.setTitle("코드전송", for: .normal)
    button.titleLabel?.font = UIFont.robotoMedium(size: 12)
    button.tintColor = UIColor.black
    button.backgroundColor = UIColor.쫄래페일그린
    button.frame = CGRect(x: CGFloat(findEmailTextField.frame.size.width-200), y: 5, width: 78, height: 27)
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: spacing, bottom: 5, right: spacing)
    findEmailTextField.rightView = button
    findEmailTextField.rightViewMode = .always
    button.addTarget(self, action: #selector(self.didTapSendCodeButton(_:)), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    let containerWidth = self.view.frame.size.width
    findEmailTextField.underlineStyle(textColor: .회, borderColor: .쫄래페일그린, width: containerWidth)
    codeTextField.underlineStyle(textColor: .회, borderColor: .쫄래페일그린, width: containerWidth)
    findEmailTextField.addSubview(SendCodeBUtton)
    setKeyboard()
  }
  
  
  @IBAction private func didTapGoToLoginButton(_ sender: UIButton){
    //TODO 로그인 화면으로 이동
    let loginViewStoryboard = UIStoryboard.init(name: "LoginView", bundle: nil)
    guard let loginVC = loginViewStoryboard.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else {return}
    self.navigationController?.popToViewController(loginVC, animated: true)
  }
  
  @objc func didTapSendCodeButton(_ sender: Any?){
    //TODO 이메일 서버와 연결
    guard let sender = sender as? UIButton else {return}
    sender.setTitle("재전송", for: .normal)
    
  }
}

extension FindPasswordViewController {
  //MARK: - KeybaordSetting
  private func setKeyboard() {
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))
    view.addGestureRecognizer(tapGesture)
    
  NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { (notification) in
      guard let userInfo = notification.userInfo else {
          return
      }
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

