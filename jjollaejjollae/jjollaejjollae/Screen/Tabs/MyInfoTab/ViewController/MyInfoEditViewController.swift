//
//  MyInfoEditViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/04.
//

import UIKit

class MyInfoEditViewController: UIViewController, StoryboardInstantiable, UITextFieldDelegate {
  
  var infoData: User? {
    didSet {
      emailTextField.text = infoData?.email
      nickTextField.text = infoData?.nick
      if infoData?.accountType == "local" {
        passwordTextField.isHidden = false
      } else {
        passwordTextField.isHidden = true
      }
    }
  }
  
  @IBOutlet weak var nickTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var logoutButton: UIButton! {
    didSet {
      logoutButton.titleLabel?.font = .robotoRegular(size: 12)
      logoutButton.setTitleColor(.gray04, for: .normal)
    }
  }
  
  @IBOutlet weak var secessionButton: UIButton! {
    didSet {
      secessionButton.titleLabel?.font = .robotoRegular(size: 12)
      secessionButton.setTitleColor(.gray04, for: .normal)
    }
  }
  
  private func applyTextField(to textfields: [UITextField]) {
    textfields.forEach { (textfield) in
      textfield.addLeftPadding()
      textfield.borderStyle = .none
      textfield.delegate = self
      UITextField.appearance().tintColor = .gray03
      textfield.underlineStyle(textColor: .gray03, borderColor: .themePaleGreen, width: self.view.frame.width)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    applyTextField(to: [nickTextField, emailTextField, passwordTextField])
   
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}

