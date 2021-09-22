//
//  AdditionalInfoViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/07.
//

import UIKit

class AdditionalInfoViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.titleStyle(text: "거의 완성했어요!")
    }
  }
  @IBOutlet var whiteLabels: [UILabel]! {
    didSet {
      whiteLabels.forEach { (label) in
        label.titleStyle(text: "처")
        label.alpha = 0
        }
    }
  }
  @IBOutlet weak var nickNameTextField: UITextField! {
    didSet {
      nickNameTextField.addLeftPadding()
    }
  }
  
  @IBOutlet weak var nickNameSameErrorLabel: UILabel! {
    didSet {
      nickNameSameErrorLabel.text = "닉네임이 중복되었습니다."
      nickNameSameErrorLabel.textColor = UIColor.errorColor
      nickNameSameErrorLabel.font = UIFont.robotoMedium(size: 14)
      nickNameSameErrorLabel.alpha = 0
    }
  }
  @IBOutlet weak var phoneNumberTextField: UITextField! {
    didSet {
      phoneNumberTextField.addLeftPadding()
    }
  }
  @IBOutlet weak var startButton: UIButton! {
    didSet {
      startButton.setTitle("시작하기", for: .normal)
      startButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      startButton.titleLabel?.textColor = UIColor.white
      startButton.tintColor = UIColor.white
      startButton.setRounded(radius: 25)
      startButton.backgroundColor = UIColor.themeGreen
    }
  }
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  private var signUpModel: SignUp = SignUp()
  var signUpData: SignUpData?
  internal func setData(data: SignUp) {
    self.signUpModel = data
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let containerViewWidth = self.view.frame.size.width
    nickNameTextField.underlineStyle(textColor: UIColor.gray04, borderColor: UIColor.themePaleGreen, width: containerViewWidth)
    phoneNumberTextField.underlineStyle(textColor: UIColor.gray04, borderColor: UIColor.themePaleGreen, width: containerViewWidth)
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
  
  @IBAction private func didTapStartButton(_ sender: UIButton) {
      //pop to homeVC
    guard let nick = nickNameTextField.text, let phone = phoneNumberTextField.text else {return}
    signUpModel.nick = nick
    signUpModel.phone = phone
    APIService.shared.signup(email: signUpModel.email, password: signUpModel.password,
                             nick: signUpModel.nick,
                             phone: signUpModel.phone) { [weak self] result in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        self.signUpData = data
        let dogInfoStoryboard = UIStoryboard(name: "DogInfo", bundle: nil)
        guard let dogInfoVC = dogInfoStoryboard.instantiateViewController(identifier: "DogInfoViewController") as? DogInfoViewController else { return }

        if #available(iOS 13, *) {
          dogInfoVC.isModalInPresentation = true
        } else {
          dogInfoVC.modalPresentationStyle = .currentContext
        }
        self.present(dogInfoVC, animated: true, completion: nil)
      case .failure(let error):
        print(error)
        if error >= 400 && error < 500 {
          let alertVC = UIAlertController(title: "오류", message: "서버 연결이 끊겼습니다.",
                                          preferredStyle: .alert)
          alertVC.addAction(UIAlertAction(title: "예", style: .default, handler: nil))
          alertVC.present(alertVC, animated: true, completion: nil)
        }
      }
    }
//    let FindPasswordStoryboard = UIStoryboard.init(name: "FindPassword", bundle: nil)
//    guard let FindPasswordVC = FindPasswordStoryboard.instantiateViewController(identifier: "FindPasswordViewController") as? FindPasswordViewController else { return }
//    self.navigationController?.pushViewController(FindPasswordVC, animated: true)
    }
  
  @IBAction private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true);
  }
}
