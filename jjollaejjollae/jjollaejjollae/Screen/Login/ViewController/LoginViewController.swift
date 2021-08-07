//
//  LoginViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/04.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField! {
      didSet {
        emailTextField.addLeftPadding()
      }
    }
    @IBOutlet var topLoginTitle: UILabel! {
      didSet {
        topLoginTitle.text = "반려동물과"
        topLoginTitle.font = UIFont.robotoBold(size: 30)
        topLoginTitle.textColor = UIColor.쥐색383838
      }
    }
    @IBOutlet var bottomLoginTitle: UILabel! {
      didSet {
        bottomLoginTitle.text = "여행을 떠나 볼까요?"
        bottomLoginTitle.font = UIFont.robotoBold(size: 30)
        bottomLoginTitle.textColor = UIColor.쥐색383838
      }
    }
    @IBOutlet var continueButton: UIButton! {
      didSet {
//        continueButton.isEnabled = false
        continueButton.setTitle("계속하기", for: .normal)
        continueButton.titleLabel?.font = UIFont.robotoBold(size: 18)
        continueButton.titleLabel?.textColor = UIColor.white
        continueButton.tintColor = UIColor.white
        continueButton.setRounded(radius: 25)
        continueButton.backgroundColor = UIColor.쫄래그린.withAlphaComponent(0.5)
      }
    }
    @IBOutlet var goToHomeButton: UIButton! {
      didSet {
        goToHomeButton.setTitle("맞춤정보 없이 둘러보기", for: .normal)
        goToHomeButton.titleLabel?.font = UIFont.robotoBold(size: 16)
        goToHomeButton.titleLabel?.textColor = UIColor.연회
        goToHomeButton.tintColor = UIColor.연회
        goToHomeButton.backgroundColor = .none
        goToHomeButton.layer.borderWidth = 0
      }
    }
    @IBOutlet var naverLoginButton: UIButton! {
      didSet {
        naverLoginButton.setTitle("네이버 로그인", for: .normal)
        naverLoginButton.roundedButton(cornerRadius: 25)
        naverLoginButton.backgroundColor = UIColor(rgb: 0x75D15D)
        naverLoginButton.titleLabel?.font = UIFont.robotoBold(size: 18)
        naverLoginButton.tintColor = UIColor.white
        naverLoginButton.titleLabel?.textColor = UIColor.white
      }
    }
    @IBOutlet var kakaoLoginButton: UIButton! {
      didSet {
        kakaoLoginButton.setTitle("카카오 로그인", for: .normal)
        kakaoLoginButton.setRounded(radius: 25)
        kakaoLoginButton.backgroundColor = UIColor(rgb: 0xFFE841)
        kakaoLoginButton.titleLabel?.font = UIFont.robotoBold(size: 18)
        kakaoLoginButton.tintColor = UIColor.black
        kakaoLoginButton.titleLabel?.textColor = UIColor.black
      }
    }
    @IBOutlet var appleLoginButton: UIButton! {
      didSet {
        appleLoginButton.setTitle("애플 로그인", for: .normal)
        appleLoginButton.setRounded(radius: 25)
        appleLoginButton.backgroundColor = UIColor.black
        appleLoginButton.titleLabel?.font = UIFont.robotoBold(size: 18)
        appleLoginButton.tintColor = UIColor.white
        appleLoginButton.titleLabel?.textColor = UIColor.white
      }
    }
    @IBOutlet var provisionLabel: UILabel! {
      didSet {
        provisionLabel.text = "계속 진행하면 쫄래쫄래의 서비스 약관 및 개인정보 보호정책에 동의한 것으로 간주됩니다."
        provisionLabel.font = UIFont.robotoMedium(size: 12)
        provisionLabel.textColor = .black
      }
    }
    @IBOutlet var errorLabel: UILabel! {
        didSet {
            errorLabel.text = "가입되지 않은 이메일입니다."
            errorLabel.textColor = UIColor.errorColor
            errorLabel.isHidden = true
            errorLabel.font = UIFont.robotoMedium(size: 14)
        }
    }
    
    private let loginManager = LoginManager()
    private var errorText: String = "가입되지 않은 이메일입니다."{
        didSet {
            errorLabel.text = "\(errorText)"
        }
    }
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
      let tapGesture = UITapGestureRecognizer(
        target: view,
        action: #selector(view.endEditing(_:)))
      view.addGestureRecognizer(tapGesture)
        emailTextField.underlineStyle(
            textColor: UIColor.회,
            borderColor: UIColor.쫄래페일그린, width: self.view.frame.width)
        
        emailTextField.addTarget(self, action: #selector(updateEmailValidationUI(_:)), for: .editingChanged)
    }
    
    @IBAction private func didTapContinueButton(_ sender: UIButton) {
        
       //TODO: 이메일
        
        
        let passwordStoryboard = UIStoryboard.init(name: "Password", bundle: nil)
        guard let passwordVC = passwordStoryboard.instantiateViewController(identifier: "PasswordViewController") as? PasswordViewController else {return}
        let signUpStoryBoard = UIStoryboard.init(name: "SignUp", bundle: nil)
        guard let signUpVC = signUpStoryBoard.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController else {return}
        
        
//        self.navigationController?.pushViewController(passwordVC, animated: true)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    @IBAction private func didTapGotoHome(_ sender: UIButton) {
        
    }
    @IBAction private func didTapNaverLoginButton(_ sender: UIButton) {
        
    }
    @IBAction private func didTapKakaoLoginButton(_ sender: UIButton) {
        
    }
    @IBAction private func didTapAppleLoginButton(_ sender: UIButton) {
        
    }
}

extension LoginViewController: UITextFieldDelegate {
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

extension LoginViewController {
    //MARK: - updateUI Methods
    @objc func updateEmailValidationUI(_ sender: Any?){
        guard let emailStr = self.emailTextField.text else {return}
        if !loginManager.isValidEmail(email: emailStr) {
            errorLabel.isHidden = false
            emailTextField.changeUnderLine(borderColor: .errorColor, width: self.view.frame.size.width)
            self.errorText = "올바른 형식의 email이 아닙니다."
        } else {
            emailTextField.changeUnderLine(borderColor: .쫄래페일그린, width: self.view.frame.size.width)
            self.errorText = ""
        }
    }
}
