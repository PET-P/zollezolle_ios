//
//  PasswordViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/06.
//

import UIKit

class PasswordViewController: UIViewController {
    
    @IBOutlet var topPasswordLabel: UILabel! {
      didSet {
        topPasswordLabel.text = "비밀번호를"
        topPasswordLabel.font = UIFont.robotoBold(size: 30)
        topPasswordLabel.textColor = UIColor.쥐색383838
      }
    }
    @IBOutlet var bottomPasswordLabel: UILabel! {
      didSet {
        bottomPasswordLabel.text = "입력해주세요"
        bottomPasswordLabel.font = UIFont.robotoBold(size: 30)
        bottomPasswordLabel.textColor = UIColor.쥐색383838
      }
    }
    @IBOutlet var passwordTextField: UITextField! {
        didSet {
            passwordTextField.underlineStyle(
                textColor: UIColor.회,
                borderColor: UIColor.쫄래페일그린)
            passwordTextField.addLeftPadding()
        }
    }
    @IBOutlet var LoginButton: UIButton! {
        didSet {
            LoginButton.setTitle("로그인", for: .normal)
            LoginButton.titleLabel?.font = UIFont.robotoBold(size: 18)
            LoginButton.titleLabel?.textColor = UIColor.white
            LoginButton.tintColor = UIColor.white
            LoginButton.setRounded(radius: 25)
            LoginButton.backgroundColor = UIColor.쫄래그린
        }
    }
    @IBOutlet var passwordErrorLabel: UILabel! {
        didSet {
            passwordErrorLabel.isHidden = true
            passwordErrorLabel.textColor = UIColor.errorColor
            passwordErrorLabel.font = UIFont.robotoMedium(size: 14)
        }
    }
    @IBOutlet var findPasswordButton: UIButton! {
        didSet {
//            findPasswordButton.isHidden = true
            findPasswordButton.underLine(buttonString: "비밀번호를 잊으셨나요?")
        }
    }
    
    private var passwordError = "" {
        didSet {
            passwordErrorLabel.text = "\(passwordError)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(
          target: view,
          action: #selector(view.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
}

extension PasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
