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
      nickNameSameErrorLabel.text = "이메일이 중복되었습니다."
      nickNameSameErrorLabel.textColor = UIColor.errorColor
      nickNameSameErrorLabel.font = UIFont.robotoMedium(size: 14)
      nickNameSameErrorLabel.isHidden = false
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
      startButton.backgroundColor = UIColor.쫄래그린
    }
  }
  @IBOutlet var stackView: UIStackView!
  @IBOutlet var scrollView: UIScrollView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let containerViewWidth = self.view.frame.size.width
    nickNameTextField.underlineStyle(textColor: UIColor.연회, borderColor: UIColor.쫄래페일그린, width: containerViewWidth)
    phoneNumberTextField.underlineStyle(textColor: UIColor.연회, borderColor: UIColor.쫄래페일그린, width: containerViewWidth)
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
    let FindPasswordStoryboard = UIStoryboard.init(name: "FindPassword", bundle: nil)
    guard let FindPasswordVC = FindPasswordStoryboard.instantiateViewController(identifier: "FindPasswordViewController") as? FindPasswordViewController else { return }
    self.navigationController?.pushViewController(FindPasswordVC, animated: true)
    }
  
  @IBAction private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true);
  }
}
