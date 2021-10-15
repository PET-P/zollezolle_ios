//
//  FindPasswordViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/08.
//

import UIKit

class FindPasswordViewController: UIViewController, StoryboardInstantiable {
  
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
  @IBOutlet weak var codeErrorLabel: UILabel! {
    didSet {
      codeErrorLabel.alpha = 0
      codeErrorLabel.textColor = UIColor.errorColor
      codeErrorLabel.font = UIFont.robotoMedium(size: 14)
      codeErrorLabel.text = "코드를 입력해주세요"
    }
  }
  
  @IBOutlet weak var emailErrorLabel: UILabel! {
    didSet {
      emailErrorLabel.alpha = 0
      emailErrorLabel.textColor = UIColor.errorColor
      emailErrorLabel.font = UIFont.robotoMedium(size: 14)
      emailErrorLabel.text = "코드를 입력해주세요"
    }
  }
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var goToLoginButton: UIButton! {
    didSet {
      goToLoginButton.setTitle("로그인", for: .normal)
      goToLoginButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      goToLoginButton.titleLabel?.textColor = UIColor.white
      goToLoginButton.tintColor = UIColor.white
      goToLoginButton.setRounded(radius: 25)
      goToLoginButton.backgroundColor = UIColor.themeGreen
    }
  }
  
  private lazy var SendCodeBUtton: UIButton = {
    let button = UIButton(type: .custom)
    let spacing: CGFloat = 15.0
    button.roundedButton(cornerRadius: 14)
    button.setTitle("코드전송", for: .normal)
    button.titleLabel?.font = UIFont.robotoMedium(size: 12)
    button.tintColor = UIColor.black
    button.backgroundColor = UIColor.themePaleGreen
    button.frame = CGRect(x: CGFloat(findEmailTextField.frame.size.width-200), y: 5, width: 78, height: 27)
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: spacing, bottom: 5, right: spacing)
    findEmailTextField.rightView = button
    findEmailTextField.rightViewMode = .always
    button.addTarget(self, action: #selector(self.didTapSendCodeButton(_:)), for: .touchUpInside)
    return button
  }()
  
  private var email: String?
  private var codeErrorLabelText: String = "코드를 입력해주세요" {
    didSet {
      codeErrorLabel.text = codeErrorLabelText
    }
  }
  
  //status 빈코드, 틀린코드

  override func viewDidLoad() {
    super.viewDidLoad()
    let containerWidth = self.view.frame.size.width
    findEmailTextField.underlineStyle(textColor: .gray03, borderColor: .themePaleGreen, width: containerWidth)
    codeTextField.underlineStyle(textColor: .gray03, borderColor: .themePaleGreen, width: containerWidth)
    findEmailTextField.text = email
    findEmailTextField.addSubview(SendCodeBUtton)
    setKeyboard()
  }
  
  @IBAction private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  internal func setEmail(email: String) {
    self.email = email
  }
  
  @IBAction private func didTapGoToLoginButton(_ sender: UIButton){
    //TODO 로그인 화면으로 이동
    //TODO 근데 이건 비번 어디서알려줌/?
    guard let email = findEmailTextField.text else {return}
    guard let code = codeTextField.text else {
      
      return }
    //TODO 서버통신
//    let loginViewStoryboard = UIStoryboard.init(name: "LoginView", bundle: nil)
//    guard let loginVC = loginViewStoryboard.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else {return}
//    self.navigationController?.popToViewController(loginVC, animated: true)
    
    // sosvast@cau.ac.kr
  }
  
  // 변화감지일때
  @objc private func updateTextFieldUI(_ sender: Any?) {
    if codeErrorLabelText == "코드를 입력해주세요" || codeErrorLabelText == "잘못된 코드입니다." {
      codeTextField.changeUnderLine(borderColor: .errorColor, width: 1)
    }
  }
  
  @objc private func didTapSendCodeButton(_ sender: Any?){
    //TODO 이메일 서버와 연결
    guard let sender = sender as? UIButton else {return}
    guard let email = findEmailTextField.text else {return}
    APIService.shared.findPassword(email: email) { [weak self](result) in
      guard let self = self else {return}
      switch result{
      case .success(let body):
        print(body)
      case .failure(let error):
        if error >= 400 && error < 500 {
          print("인증코드가 발송되지 않았습니다. 다시 시도해주세요")
        }
      }
    }
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

