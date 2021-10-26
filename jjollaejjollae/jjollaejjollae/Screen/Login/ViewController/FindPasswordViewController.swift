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
  @IBOutlet weak var noticeView: UIView! {
    didSet {
      noticeView.backgroundColor = .gray06
      noticeView.setRounded(radius: 5)
    }
  }
  @IBOutlet weak var codeErrorLabel: UILabel! {
    didSet {
      codeErrorLabel.textColor = UIColor.gray03
      codeErrorLabel.font = UIFont.robotoRegular(size: 13)
      codeErrorLabel.text = "해당 비밀번호로 로그인 후\n 반드시 비밀번호를 변경해주세요"
      codeErrorLabel.numberOfLines = 2
    }
  }
  
  @IBOutlet weak var noticeLabel: UILabel!
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
  @IBOutlet weak var resendButton: UIButton! {
    didSet {
      resendButton.addBorder([.bottom], color: .gray03, width: 1)
      resendButton.setTitleColor(.gray03, for: .normal)
      resendButton.titleLabel?.font = .robotoMedium(size: 14)
      resendButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
    }
  }
  
  private var email: String?
  private var codeErrorLabelText: String = "코드를 입력해주세요" {
    didSet {
      codeErrorLabel.text = codeErrorLabelText
    }
  }
  
  //status 빈코드, 틀린코드
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNoticeLabel()
  }
  
  private func setNoticeLabel() {
    if let email = email {
      let text = "\(email)로\n 임시비밀번호가 전송되었습니다."
      let attributedString = NSMutableAttributedString(string: text)
      attributedString.addAttributes([NSAttributedString.Key.font : UIFont.robotoBold(size: 18), NSAttributedString.Key.foregroundColor: UIColor.gray01], range: (text as NSString).range(of: "\(email)"))
      noticeLabel.attributedText = attributedString
      noticeLabel.numberOfLines = 2
    } else {
      noticeLabel.text = "존재하지 않는 이메일입니다."
      noticeLabel.font = .robotoBold(size: 18)
      noticeLabel.textColor = .gray01
    }
  }
  
  
  @IBAction private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  internal func setEmail(email: String) {
    self.email = email
  }
  
  @IBAction private func didTapGoToLoginButton(_ sender: UIButton){
    guard let loginVC = LoginViewController.loadFromStoryboard() as? LoginViewController else {return}
    self.navigationController?.pushViewController(loginVC, animated: true)
  }
  
  @IBAction func didTapResendButton(_ sender: UIButton) {
    guard let email = email else {
      return
    }
    let alert = UIAlertController(title: "재전송", message: "\(email)으로 비밀번호를 재전송하시겠습니까?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "네", style: .default, handler: { action in
      APIService.shared.tempPassword(email: email) { [weak self] result in
        switch result {
        case .success:
          guard let findPasswordVC = FindPasswordViewController.loadFromStoryboard() as? FindPasswordViewController else {return}
          findPasswordVC.setEmail(email: email)
          self?.navigationController?.pushViewController(findPasswordVC, animated: true)
        case .failure(let error):
          print(#function, error)
          self?.dismiss(animated: true, completion: nil)
        }
      }
    }))
  self.present(alert, animated: true, completion: nil)
  }
  
  
}
