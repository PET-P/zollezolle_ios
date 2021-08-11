//
//  DogInfoViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/08.
//

import UIKit

class DogInfoViewController: UIViewController {
  //MARK: - IBOUTLET

  @IBOutlet weak var infoTitleLabel: UILabel! {
    didSet {
      infoTitleLabel.text = "정보등록"
      infoTitleLabel.font = UIFont.robotoBold(size: 24)
      infoTitleLabel.textColor = .black
    }
  }
  @IBOutlet weak var infoSubTitleLabel: UILabel! {
    didSet {
      infoSubTitleLabel.text = "친구에게 맞는 여행정보를 추천받아 보세요."
      infoSubTitleLabel.font = UIFont.robotoMedium(size: 14)
      infoSubTitleLabel.textColor = .black
    }
  }
  @IBOutlet weak var myPetImageView: UIImageView! {
    didSet {
      myPetImageView.setRounded(radius: nil)
      myPetImageView.layer.borderWidth = 1
      myPetImageView.layer.borderColor = UIColor.clear.cgColor
      myPetImageView.clipsToBounds = true
    }
  }
  @IBOutlet weak var myPetNameTextField: UITextField! {
    didSet {
      myPetNameTextField.setRounded(radius: nil)
      myPetNameTextField.backgroundColor = .쫄래페일그린
      myPetNameTextField.font = .robotoBold(size: 18)
      myPetNameTextField.placeholder = "쪼꼬"
    }
  }
  @IBOutlet weak var petAgeLabel: PaddingLabel! {
    didSet {
      petAgeLabel.text = "나이"
      petAgeLabel.font = UIFont.robotoMedium(size: 14)
    }
  }
  @IBOutlet weak var petAgeTextField: UITextField! {
    didSet {
      petAgeTextField.setRounded(radius: nil)
      petAgeTextField.layer.borderWidth = 1
      petAgeTextField.layer.borderColor = UIColor.쫄래페일그린.cgColor
      petAgeTextField.font = .robotoMedium(size: 16)
      petAgeTextField.placeholder = "4살"
      petAgeTextField.textColor = UIColor.쥐색38
    }
  }
  @IBOutlet weak var petGenderLabel: PaddingLabel! {
    didSet {
      petGenderLabel.text = "성별"
      petGenderLabel.font = .robotoMedium(size: 14)
    }
  }
  @IBOutlet weak var petGenderSwitch: JJollaeSwitch!
  @IBOutlet weak var petSizeLabel: PaddingLabel! {
    didSet {
      petSizeLabel.text = "크기"
      petSizeLabel.font = .robotoMedium(size: 14)
    }
  }
  @IBOutlet weak var petSizeButton: UIButton! {
    didSet {
      petSizeButton.setRounded(radius: nil)
      petSizeButton.layer.borderColor = UIColor.쫄래페일그린.cgColor
      petSizeButton.layer.borderWidth = 1
      petSizeButton.setTitle("소형", for: .normal)
      petSizeButton.tintColor = UIColor.쥐색38
      petSizeButton.titleLabel?.font = .robotoMedium(size: 16)
    }
  }
  @IBOutlet weak var petWeightLabel: PaddingLabel! {
    didSet {
      petWeightLabel.text = "무게"
      petWeightLabel.font = .robotoMedium(size: 14)
    }
  }
  @IBOutlet weak var petWeightTextField: UITextField! {
    didSet {
      petWeightTextField.setRounded(radius: nil)
      petWeightTextField.layer.borderWidth = 1
      petWeightTextField.layer.borderColor = UIColor.쫄래페일그린.cgColor
      petWeightTextField.font = .robotoMedium(size: 16)
      petWeightTextField.textColor = UIColor.쥐색38
    }
  }
  @IBOutlet weak var petTypeLabel: PaddingLabel! {
    didSet {
      petTypeLabel.text = "종류"
      petTypeLabel.font = .robotoMedium(size: 14)
    }
  }
  @IBOutlet weak var petTypeButton: UIButton! {
    didSet {
      petTypeButton.layer.cornerRadius = petTypeButton.frame.height / 2
      petTypeButton.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner,
                                                       .layerMinXMaxYCorner)
      petTypeButton.layer.borderColor = UIColor.쫄래페일그린.cgColor
      petTypeButton.layer.borderWidth = 1
      petTypeButton.setTitle("강아지", for: .normal)
      petTypeButton.tintColor = UIColor.쥐색38
      petTypeButton.titleLabel?.font = .robotoMedium(size: 16)
    }
  }

  @IBOutlet weak var petTypeTextField: UITextField! {
    didSet {
      petTypeTextField.placeholder = "아기의 품종을 써주세요!"
      petTypeTextField.layer.borderWidth = 1
      petTypeTextField.layer.borderColor = UIColor.쫄래페일그린.cgColor
      petTypeTextField.font = .robotoMedium(size: 16)
      petTypeTextField.textColor = UIColor.쥐색38
      petTypeTextField.layer.cornerRadius = petTypeTextField.layer.frame.height / 2
      petTypeTextField.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner,
                                                          .layerMaxXMinYCorner)
    }
  }
  @IBOutlet weak var saveButton: UIButton! {
    didSet {
      saveButton.setTitle("저장", for: .normal)
      saveButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      saveButton.titleLabel?.textColor = UIColor.white
      saveButton.tintColor = UIColor.white
      saveButton.setRounded(radius: 25)
      saveButton.backgroundColor = UIColor.쫄래그린
    }
  }
  @IBOutlet weak var ContinueWithoutSaveButton: UIButton! {
    didSet {
      ContinueWithoutSaveButton.setTitle("맞춤정보 없이 둘러보기", for: .normal)
      ContinueWithoutSaveButton.titleLabel?.textColor = UIColor.연회
      ContinueWithoutSaveButton.tintColor = UIColor.연회
      ContinueWithoutSaveButton.backgroundColor = .none
      ContinueWithoutSaveButton.layer.borderWidth = 0
    }
  }
  @IBOutlet var stackView: UIStackView!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var targetStackview: UIStackView!
  private let imagePickerController: UIImagePickerController = UIImagePickerController()

  private var sizeText: String = "소형" {
    didSet {
      petSizeButton.setTitle("\(sizeText)", for: .normal)
    }
  }
  
  private var typeText: String = "강아지" {
    didSet {
      petTypeButton.setTitle("\(typeText)", for: .normal)
    }
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGestureAboveImageView()
    setKeyboard()
  }
  
  private func addGestureAboveImageView(){
    let tapImageView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
    myPetImageView.addGestureRecognizer(tapImageView)
    myPetImageView.isUserInteractionEnabled = true
  }
  
  @objc private func didTapImageView(_ sender: Any?){
    let myPetImagePickerController: UIImagePickerController = UIImagePickerController()
    myPetImagePickerController.allowsEditing = true
    myPetImagePickerController.delegate = self
    present(myPetImagePickerController, animated: true, completion: nil)
  }
}

extension DogInfoViewController: UITextFieldDelegate {
  private func setKeyboard() {
    myPetNameTextField.delegate = self
    petAgeTextField.delegate = self
    petTypeTextField.delegate = self
    petWeightTextField.delegate = self
    
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))

    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    
  NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                         object: nil,
                                         queue: OperationQueue.main) { (notification) in
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
      guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
              as? TimeInterval else {return}
      UIView.animate(withDuration: duration) {
          self.view.layoutIfNeeded()
      }
    }
  NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                         object: nil,
                                         queue: OperationQueue.main) { (notification) in
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
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

//MARK: - ImagePicker 제공

extension DogInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      self.myPetImageView.image = originalImage
      //TODO: 이미지 저장할 모델링
      //TODO: 정한 이미지 pan gesture
    }
    self.dismiss(animated: true, completion: nil)
  }
}
