//
//  MyInfoEditViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/04.
//

import UIKit
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import SwiftyJSON

class MyInfoEditViewController: UIViewController, StoryboardInstantiable, UITextFieldDelegate {
  
  var infoData: UserData? {
    didSet {
      emailTextField.text = infoData?.email
      nickTextField.text = infoData?.nick
    }
  }
  
  private let alphaVal: CGFloat = 0.4
  let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
  
  @IBOutlet weak var nickTextField: UITextField! {
    didSet {
      nickTextField.text = UserManager.shared.userInfo?.nick
    }
  }
  @IBOutlet weak var emailTextField: UITextField! {
    didSet {
      emailTextField.isUserInteractionEnabled = false
      emailTextField.text = UserManager.shared.userInfo?.email
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

  @IBOutlet weak var dogProfileImage: UIImageView!
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
  @IBOutlet weak var newPasswordTextfield: UITextField!
  
  @IBOutlet weak var phoneStackView: UIStackView!
  private func applyGrayStyle(to textfields: [UITextField]) {
    textfields.forEach { (textfield) in
      textfield.delegate = self
      textfield.backgroundColor = .gray06
    }
  }
  
  private var dogImage: UIImage?
  
  @IBAction func didChangeNickOrPassword(_ sender: UITextField) {
    guard let newText = sender.text, newText != "" else {
      sender.text = infoData?.nick
      return}
    switch sender.tag {
    case 0:
      if newText != infoData?.nick {
        let alert = UIAlertController(title: "닉네임 변경", message: "\(newText)로 변경하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: { [weak self](action) in
          guard let self = self else {return}
          self.infoData?.nick = newText
          guard let token = UserManager.shared.userIdandToken?.token, let userId = UserManager.shared.userIdandToken?.userId else {return}
          APIService.shared.patchUser(token: token, userId: userId, nick: newText, phone: nil, password: nil) { (result) in
            switch result {
            case .success(let data):
              let data = JSON(data)
              print(data.rawValue)
            case .failure(let error):
              print(error)
            }
          }
        }))
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: { [weak self](action) in
          guard let self = self else {return}
          sender.text = self.infoData?.nick
        }))
        present(alert, animated: true, completion: nil)
      }
    case 1:
      if newText != infoData?.nick {
        let alert = UIAlertController(title: "비밀번호 변경", message: "새로운 비밀번호로 변경하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: { [weak self](action) in
          self?.infoData?.nick = newText
          guard let token = UserManager.shared.userIdandToken?.token, let userId = UserManager.shared.userIdandToken?.userId else {return}
          APIService.shared.patchUser(token: token, userId: userId, nick: nil, phone: nil, password: newText) { (result) in
            switch result {
            case .success(let data):
              let data = JSON(data)
              print(data.rawValue)
            case .failure(let error):
              print(error)
            }
          }
        }))
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: { [weak self](action) in
          sender.text = self?.infoData?.nick
        }))
        present(alert, animated: true, completion: nil)
      }
    default:
      return
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
  
  @IBAction func didTapSecessionButton(_ sender: UIButton) {
    showSeccessionAlert()
  }
  
  @IBAction func didTapLogoutButton(_ sender: UIButton) {
    UserManager.shared.deleteUser()
    print("logout")
  }
  
  
  @IBAction func didTapEditPhoneButton(_ sender: UIButton) {
    guard let phoneNum = phoneTextField.text else {return}
    guard phoneNum == infoData?.phone else {return}
    let alert = UIAlertController(title: "휴대폰 번호 변경", message: "\(phoneNum)로 변경하시겠습니까?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "네", style: .default, handler: { [weak self](action) in
      self?.infoData?.phone = phoneNum
      guard let token = UserManager.shared.userIdandToken?.token, let userId = UserManager.shared.userIdandToken?.userId else {return}
      APIService.shared.patchUser(token: token, userId: userId, nick: nil, phone: phoneNum, password: nil) { (result) in
        switch result {
        case .success(let data):
          let data = JSON(data)
          print(data.rawValue)
        case .failure(let error):
          print(error)
        }
      }

    }))
    alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: { [weak self](action) in
      self?.phoneTextField.text = self?.infoData?.phone
    }))
    present(alert, animated: true, completion: nil)
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
  
  private func showSeccessionAlert(){
    guard let usertype = UserManager.shared.userInfo?.accountType else {return}
    var secessionAlertController: UIAlertController!
    var ok: UIAlertAction!
    if usertype == .local {
      secessionAlertController = UIAlertController(title: "탈퇴하기", message: "회원탈퇴를 하시려면 안내 및 동의가 필요합니다.비밀번호를 입력해주세요", preferredStyle: .alert)
      secessionAlertController.addTextField { (password) in
        print("서버와 연동해서 password가 맞는지 확인을해야한딩")
      }
      ok = UIAlertAction(title: "진행하기", style: .default) { [weak self](ok) in
        guard let token = UserManager.shared.userIdandToken?.token else {return}
        guard let self = self else {return}
        guard let userId = self.infoData?.id else {return}
        //1.우리서버에서 회원삭제
        APIService.shared.deleteUser(token: token, userId: userId) { [weak self] result in
          switch result{
          case .success:
            UserManager.shared.deleteUser()
            self?.navigationController?.popToRootViewController(animated: true)
          case .failure(let error):
            print("errorCode: ", error)
          }
        }
      }
    } else {
      if usertype == .unknown {return}
      secessionAlertController = UIAlertController(title: "탈퇴하기", message: "회원탈퇴를 하시려면 안내 및 동의가 필요합니다.", preferredStyle: .alert)
      ok = UIAlertAction(title: "진행하기", style: .default) { [weak self](ok) in
        guard let token = UserManager.shared.userIdandToken?.token else {return}
        guard let self = self else {return}
        guard let userId = self.infoData?.id else {return}
        
        if usertype == .naver {self.loginInstance?.requestDeleteToken()}
        else if usertype == .kakao {
          UserApi.shared.unlink { (error) in
            if let error = error {
              print(error)
            }
            else {
              print("카카오 연결끊기 성공")
            }
          }
        }
        else {
          //apple login token 삭제
        }
        APIService.shared.deleteUser(token: token, userId: userId) { [weak self] result in
          switch result{
          case .success:
            print("성공")
            UserManager.shared.deleteUser()
            self?.navigationController?.popToRootViewController(animated: true)
            
          case .failure(let error):
            print("errorCode: ", error)
          }
        }
      }
    }
    let cancel = UIAlertAction(title: "취소", style: .cancel) { (cancel) in
      print("탈퇴안하기")
    }
    secessionAlertController.addAction(cancel)
    secessionAlertController.addAction(ok)
    self.present(secessionAlertController, animated: true, completion: nil)
  }
  
  private func verifySocial(){
    if infoData?.accountType.rawValue != "local" {
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
    dogProfileImage.setRounded(radius: nil)
    infoData = UserManager.shared.userInfo
    applyNoneSyle(to: [emailTextField, phoneTextField])
    applyGrayStyle(to: [nickTextField, currentPWTextField, newPWTextField])
    verifySocial()
    guard let userId = UserManager.shared.userIdandToken?.userId, let token = UserManager.shared.userIdandToken?.token else {return}
    //여기서는 한마리만 따오고,
    if self.dogImage != nil {return}
    APIService.shared.readPets(token: token, userId: userId) { [weak self] (result) in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        for i in data {
          if i.isRepresent == true {
            StorageService.shared.downloadUIImageWithURL(with: i.imageUrl ?? "default.") { (image) in
              guard let image = image else {
                return
              }
              self.dogImage = image
              self.dogProfileImage.image = self.dogImage
              return
            }
          }
          self.dogImage = UIImage(named: "default")
          self.dogProfileImage.image = self.dogImage
        }
      case .failure(let error):
        self.dogImage = UIImage(named: "default")
        self.dogProfileImage.image = self.dogImage
        print(error)
      }
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  //네이버용
  func oauth20ConnectionDidFinishDeleteToken() {
    print("네이버 회원탈퇴 석세스")
  }
  
  
}

