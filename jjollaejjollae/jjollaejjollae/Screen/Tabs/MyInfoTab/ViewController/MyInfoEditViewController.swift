//
//  MyInfoEditViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/04.
//

import UIKit

class MyInfoEditViewController: UIViewController, StoryboardInstantiable, UITextFieldDelegate {
  
  var infoData: UserData? {
    didSet {
      emailTextField.text = infoData?.email
      nickTextField.text = infoData?.nick
    }
  }
  
  private let alphaVal = 0.4
  
  @IBOutlet weak var nickTextField: UITextField! {
    didSet {
      nickTextField.text = UserManager.shared.UserInfo?.nick
    }
  }
  @IBOutlet weak var emailTextField: UITextField! {
    didSet {
      emailTextField.isUserInteractionEnabled = false
      emailTextField.text = UserManager.shared.UserInfo?.email
    }
  }
  
  @IBOutlet weak var currentPWTextField: UITextField!
  @IBOutlet weak var newPWTextField: UITextField! {
    didSet {
      newPWTextField.placeholder = "문자, 숫자를 모두 포함한 8자이상"
      newPWTextField.setPlaceholderColor(.gray03)
    }
  }
  @IBOutlet var infoItemsLabel: [UILabel]! {
    didSet {
      infoItemsLabel.forEach { (label) in
        label.font = .robotoMedium(size: 16)
        label.textColor = .gray02
      }
    }
  }
  @IBOutlet weak var errorLabel: UILabel! {
    didSet {
      errorLabel.textColor = .errorColor
      errorLabel.text = " "
    }
  }

  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var passwordStackView: UIStackView!
  @IBOutlet weak var newpasswordStackView: UIStackView!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var blockView: UIView!
  @IBOutlet weak var blockView2: UIView!
  @IBOutlet weak var logoutButton: UIButton! {
    didSet {
      logoutButton.titleLabel?.font = .robotoRegular(size: 12)
      logoutButton.setTitleColor(.gray04, for: .normal)
      logoutButton.underLine(buttonString: logoutButton.currentTitle!)
    }
  }
  
  @IBOutlet weak var secessionButton: UIButton! {
    didSet {
      secessionButton.titleLabel?.font = .robotoRegular(size: 12)
      secessionButton.setTitleColor(.gray04, for: .normal)
      secessionButton.underLine(buttonString: secessionButton.currentTitle!)
    }
  }
  @IBOutlet weak var editPhoneButton: UIButton! {
    didSet {
      editPhoneButton.roundedButton(cornerRadius: 10)
      editPhoneButton.backgroundColor = .gray06
      editPhoneButton.setTitleColor(.gray03, for: .normal)
    }
  }
  @IBOutlet var subtitles: [UILabel]! {
    didSet {
      subtitles.forEach({ (subtitle) in
        subtitle.font = .robotoRegular(size: 14)
        subtitle.textColor = .gray02
      })
    }
  }
  
  @IBOutlet weak var phoneStackView: UIStackView!
  private func applyGrayStyle(to textfields: [UITextField]) {
    textfields.forEach { (textfield) in
      textfield.delegate = self
      textfield.backgroundColor = .gray06
    }
  }
  
  private func applyNoneSyle(to textfields: [UITextField]) {
    textfields.forEach { (textfield) in
      textfield.borderStyle = .none
      textfield.delegate = self
      UITextField.appearance().tintColor = .gray03
      textfield.textColor = .gray04
      textfield.font = .robotoRegular(size: 16)
    }
  }
  
  @IBAction func checkPW(_ sender: UITextField) {
    let confirmed = false
    //서버와통신 method명 passwordCheck예정
    updatePWtextFieldsUI(confirm: confirmed)
  }
  
  private func updatePWtextFieldsUI(confirm: Bool){
    if confirm {
      errorText = "비밀번호가 다릅니다."
      //신규비번란 alpha 0.4로
      subtitles.last!.alpha = alphaVal
      newPWTextField.alpha = alphaVal
      // 현재 비밀번호 border
      currentPWTextField.setBorder(borderColor: .errorColor, borderWidth: 1)
    } else {
      errorText = " "
      currentPWTextField.setBorder(borderColor: .clear, borderWidth: 0)
      subtitles.last!.alpha = 1
      newPWTextField.alpha = 1
    }
    
  }
  
  private var errorText: String = "" {
    didSet {
      errorLabel.text = errorText
    }
  }
  
  private func verifySocial(){
    if infoData?.accountType == "social" {
      infoItemsLabel[1].isHidden = true
      phoneStackView.isHidden = true
      blockView.isHidden = true
      passwordLabel.isHidden = true
      passwordStackView.isHidden = true
      newpasswordStackView.isHidden = true
      blockView2.isHidden = true
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    infoData = UserManager.shared.UserInfo
    applyNoneSyle(to: [emailTextField, phoneTextField])
    applyGrayStyle(to: [nickTextField, currentPWTextField, newPWTextField])
    verifySocial()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}

