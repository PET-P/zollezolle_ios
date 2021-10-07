//
//  MyPetInfoEditViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/04.
//

import UIKit

class MyPetInfoEditViewController: UIViewController, StoryboardInstantiable, UITextFieldDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    weightPicker.delegate = self
    agePicker.delegate = self
    for i in 1...100 {
      ageList.append(i)
    }
    for i in 0...50 {
      for j in [0, 5] {
        let weightStr = "\(i).\(j)"
        let weightDou = Double(weightStr)!
        weightList.append(weightDou)
      }
    }
    addToobar()
    petAgeTextField.inputView = agePicker
    petWeightTextField.inputView = weightPicker
  }
  
  @IBOutlet weak var myPetNameTextField: UITextField! {
    didSet {
      myPetNameTextField.borderStyle = .none
      myPetNameTextField.setRounded(radius: nil)
      myPetNameTextField.backgroundColor = .themePaleGreen
      myPetNameTextField.font = .robotoBold(size: 18)
      myPetNameTextField.placeholder = "쪼꼬"
      myPetNameTextField.delegate = self
    }
  }
  @IBOutlet weak var petAgeLabel: PaddingLabel! {
    didSet {
      petAgeLabel.font = UIFont.robotoMedium(size: 14)
    }
  }

  @IBOutlet weak var petAgeTextField: UITextField! {
    didSet {
      petAgeTextField.borderStyle = .none
      petAgeTextField.setRounded(radius: nil)
      petAgeTextField.backgroundColor = UIColor.gray06
      petAgeTextField.font = .robotoMedium(size: 16)
      petAgeTextField.placeholder = "4살"
      petAgeTextField.textColor = UIColor.gray01
    }
  }
  @IBOutlet weak var petGenderLabel: PaddingLabel! {
    didSet {
      petGenderLabel.font = .robotoMedium(size: 14)
    }
  }
  @IBOutlet weak var petGenderSwitch: JJollaeSwitch! {
    didSet {
      petGenderSwitch.setButtonTitle(isOn: "남", isOff: "여")
      petGenderSwitch.setSwitchColor(onTextColor: .gray01, offTextColor: .gray01)
      petGenderSwitch.setSwitchColor(onColor: .themePaleGreen, offColor: .themePaleGreen)
      petGenderSwitch.isOn = false
      petGenderSwitch.setCircleFrame(frame: CGRect(x: 0, y: 2, width: petGenderSwitch.frame.height * 11 / 6 - 4, height: petGenderSwitch.frame.height - 4))
    }
  }
  @IBOutlet weak var petSizeLabel: PaddingLabel! {
    didSet {
      petSizeLabel.font = .robotoMedium(size: 14)
    }
  }
  @IBOutlet weak var petSizeButton: UIButton! {
    didSet {
      petSizeButton.setRounded(radius: nil)
      petSizeButton.layer.borderWidth = 0
      petSizeButton.backgroundColor = .gray06
      petSizeButton.setTitle("소형", for: .normal)
      petSizeButton.setTitleColor(.gray01, for: .normal)
      petSizeButton.titleLabel?.font = .robotoMedium(size: 16)
    }
  }
  @IBOutlet weak var petWeightLabel: PaddingLabel! {
    didSet {
      petWeightLabel.font = .robotoMedium(size: 14)
    }
  }
  @IBOutlet weak var petWeightTextField: UITextField! {
    didSet {
      petWeightTextField.borderStyle = .none
      petWeightTextField.setRounded(radius: nil)
      petWeightTextField.backgroundColor = UIColor.gray06
      petWeightTextField.font = .robotoMedium(size: 16)
      petWeightTextField.placeholder = "3kg"
      petAgeTextField.textColor = UIColor.gray01
    }
  }
  @IBOutlet weak var petTypeLabel: PaddingLabel! {
    didSet {
      petTypeLabel.font = .robotoMedium(size: 14)
    }
  }
  @IBOutlet weak var petTypeButton: UIButton! {
    didSet {
      petTypeButton.layer.cornerRadius = petTypeButton.frame.height / 2
      petTypeButton.layer.maskedCorners = CACornerMask(
        arrayLiteral: .layerMinXMinYCorner,.layerMinXMaxYCorner)
      petTypeButton.layer.borderWidth = 0
      petTypeButton.backgroundColor = .gray06
      petTypeButton.setTitle("강아지", for: .normal)
      petTypeButton.setTitleColor(.gray01, for: .normal)
      petTypeButton.titleLabel?.font = .robotoMedium(size: 16)
    }
  }
  
  @IBOutlet weak var petTypeTextField: UITextField! {
    didSet {
      petTypeTextField.placeholder = "애기의 품종?"
      petTypeTextField.borderStyle = .none
      petTypeTextField.font = .robotoMedium(size: 16)
      petTypeTextField.backgroundColor = .gray06
      petTypeTextField.textColor = UIColor.gray01
      petTypeTextField.layer.cornerRadius = petTypeTextField.layer.frame.height / 2
      petTypeTextField.layer.maskedCorners = CACornerMask(
        arrayLiteral: .layerMaxXMaxYCorner, .layerMaxXMinYCorner)
      petTypeTextField.delegate = self
    }
  }
  
  private var weightList = [Double]()
  private var ageList = [Int]()
  lazy var agePicker = UIPickerView()
  lazy var weightPicker = UIPickerView()
  
  @IBAction func didTapPetSizeButton(_ sender: UIButton) {
    self.showAlertController(style: UIAlertController.Style.actionSheet)
  }
  
  private func showAlertController(style: UIAlertController.Style) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    let bigSizeAction = UIAlertAction(title: "대형", style: .default) { _ in print("대형")
//      [weak self]
//      result in self?.sizeText = "대형"
    }
    let middleSizeAction = UIAlertAction(title: "중형", style: .default) {_ in
      print("중형")
//      [weak self] result in self?.sizeText = "중형"
    }
    let smallSizeAction = UIAlertAction(title: "소형", style: .default) {
//      [weak self] result in
      _ in print("소형")
//      self?.sizeText = "소형"
    }
    let subview = alertController.view.subviews.first! as UIView
    let alertContentView = subview.subviews.first! as UIView
    alertContentView.setRounded(radius: 10)
    alertContentView.overrideUserInterfaceStyle = .light
    alertContentView.backgroundColor = UIColor.white
    alertController.view.setRounded(radius: 10)
    alertController.view.tintColor = .themeGreen
    alertController.addAction(bigSizeAction)
    alertController.addAction(middleSizeAction)
    alertController.addAction(smallSizeAction)
    alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    self.present(alertController, animated: true, completion: nil);
  }
  
  private func showAlertController(style: UIAlertController.Style, AlertList: [String]) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    AlertList.forEach { (type) in
      alertController.addAction(UIAlertAction(title: type, style: .default) {
        _ in print("힛")
//        [weak self] result in
//        self?.typeText = type
      })
    }
    let subview = alertController.view.subviews.first! as UIView
    let alertContentView = subview.subviews.first! as UIView
    alertContentView.setRounded(radius: 10)
    alertContentView.overrideUserInterfaceStyle = .light
    alertContentView.backgroundColor = UIColor.white
    alertController.view.setRounded(radius: 10)
    alertController.view.tintColor = .themeGreen
    
    alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    self.present(alertController, animated: true, completion: nil);
  }
  
  @IBAction func didTapPetTypeButton(_ sender: UIButton) {
    self.showAlertController(style: UIAlertController.Style.actionSheet, AlertList: ["강아지", "고양이"])
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.becomeFirstResponder()
  }
  
}

extension MyPetInfoEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  private func addToobar() {
    //toobar 위치잡아주기
    self.agePicker.backgroundColor = .white
    self.weightPicker.backgroundColor = .white
    let toolbar = UIToolbar()
    toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
    toolbar.barTintColor = .white
    self.petAgeTextField.inputAccessoryView = toolbar
    self.petWeightTextField.inputAccessoryView = toolbar
    //가변 폭 버튼
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    //toorbar에 done올리기
    let done = UIBarButtonItem()
    done.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.themeGreen], for: .normal)
    done.title = "완료"
    done.target = self
    done.action = #selector(pickerDone)

    toolbar.setItems([flexSpace, done], animated: true)
  }

  @objc private func pickerDone(_ sneder: Any) {
    self.view.endEditing(true)
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    let pickerLabel = UILabel()
    pickerLabel.textAlignment = .center
    pickerLabel.textColor = .themeGreen
    pickerLabel.font = .robotoMedium(size: 24)

    if pickerView == agePicker {
      pickerLabel.text = "\(self.ageList[row])살"
    } else {
      pickerLabel.text =  "\(self.weightList[row])KG"
    }
    return pickerLabel
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == agePicker {
      return self.ageList.count
    } else {
      return self.weightList.count
    }
  }


  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == agePicker {
      let age = self.ageList[row]
      self.petAgeTextField.text = "\(age)살"
    } else {
      let weight = self.weightList[row]
      self.petWeightTextField.text = "\(weight)KG"
    }
  }
}
