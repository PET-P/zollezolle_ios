//
//  MyPetInfoEditViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/31.
//

import UIKit
import KakaoSDKUser

class MyPetInfoEditViewController: UIViewController, StoryboardInstantiable {
  
  //MARK: - IBOUTLET
  
  @IBOutlet weak var myPetNameTextField: UITextField! {
    didSet {
      myPetNameTextField.borderStyle = .none
      myPetNameTextField.setRounded(radius: nil)
      myPetNameTextField.backgroundColor = .themePaleGreen
      myPetNameTextField.font = .robotoBold(size: 18)
      myPetNameTextField.placeholder = "  쪼꼬"
      //시간이없는관계로 이렇게 넘어감
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
      petAgeTextField.borderStyle = .none
      petAgeTextField.setRounded(radius: nil)
      petAgeTextField.backgroundColor = UIColor.gray06
      petAgeTextField.font = .robotoMedium(size: 16)
      petAgeTextField.placeholder = "4살"
      petAgeTextField.textColor = UIColor.gray01
      petAgeTextField.inputView = agePicker
    }
  }
  @IBOutlet weak var petGenderLabel: PaddingLabel! {
    didSet {
      petGenderLabel.text = "성별"
      petGenderLabel.font = .robotoMedium(size: 14)
    }
  }
  @IBOutlet weak var petGenderSwitch: JJollaeSwitch! {
    didSet {
      petGenderSwitch.delegate = self
      petGenderSwitch.setButtonTitle(isOn: "남", isOff: "여")
      petGenderSwitch.setSwitchColor(onTextColor: .gray01, offTextColor: .gray01)
      petGenderSwitch.setSwitchColor(onColor: .themePaleGreen, offColor: .themePaleGreen)
      petGenderSwitch.setCircleFrame(frame: CGRect(x: 0, y: 2, width: petGenderSwitch.frame.height * 11 / 6 - 4, height: petGenderSwitch.frame.height - 4))
    }
  }
  @IBOutlet weak var petSizeLabel: PaddingLabel! {
    didSet {
      petSizeLabel.text = "크기"
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
      petWeightLabel.text = "무게"
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
      petWeightTextField.inputView = weightPicker
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
    }
  }
  @IBOutlet weak var saveButton: UIButton! {
    didSet {
      saveButton.setTitle("저장", for: .normal)
      saveButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      saveButton.titleLabel?.textColor = UIColor.white
      saveButton.tintColor = UIColor.white
      saveButton.setRounded(radius: 5)
      saveButton.backgroundColor = UIColor.themeGreen
    }
  }
  @IBOutlet weak var refreshButton: UIButton! {
    didSet {
      refreshButton.setTitle("선택해제", for: .normal)
      refreshButton.setTitleColor(.gray03, for: .normal)
      refreshButton.titleLabel?.font = .robotoMedium(size: 14)
    }
  }
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var dogProfileCollectionView: dogInfoCollectionView!
  
  private lazy var representPetButton: UIButton = {
    let button = UIButton(type: .custom)
    let spacing: CGFloat = 10.0
    button.setImage(UIImage(named: "pawUnchecked"), for: .normal)
    button.setImage(UIImage(named: "pawChecked"), for: .selected)
    button.frame = CGRect(x: 0, y: 5, width: 16, height: 20)
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: spacing, bottom: 5, right: spacing)
    myPetNameTextField.leftView = button
    myPetNameTextField.leftViewMode = .always
    button.addTarget(self, action: #selector(self.didTaprepresentPetButton(_:)), for: .touchUpInside)
    return button
  }()
  
  //MARK: - LIFECYCLE
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dogProfile = PagingManager.shared.getDogTuples()
    setPickerContents()
    addToobar()
    setKeyboard()
    myPetNameTextField.addSubview(representPetButton)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addCollectionView()
    setUpDogProfile()
  }
  
  private func setUpDogProfile() {
    var tempCellType: [State] = []
    if dogProfile.isEmpty {
      // dogprofile에 아무것도 없으면?? 처음들어가는 상황
      // 여기서 그냥 하나 그냥 생성 X
      tempCellType = [.plus]
    } else {
      // dogprofile에 처음들어가는 상황이 아님// 여기서 그냥 하나 그냥 생성 X
      for i in dogProfile.indices {
        // 이미지 설정이 되어있지 않다면?
        if dogProfile[i].pet.imageUrl == nil {
          tempCellType.append(.camera)
        } else { //이미지설정이 되어있다면?
          tempCellType.append(.old)
        }
      }
      //마지막은 plus로 마무리
      tempCellType.append(.plus)
    }
    cellType = tempCellType
  }
  
  
  
  //MARK: - VARIABLE
  private let imagePickerController: UIImagePickerController = UIImagePickerController()
  
  private var sizeText: String = "소형" {
    didSet {
      petSizeButton.setTitle("\(sizeText)", for: .normal)
      
      if petSizeButton.currentTitle == "소형" {
        dogProfile[middleIndex.row].pet.size = .small
        
      } else if petSizeButton.currentTitle == "중형" {
        dogProfile[middleIndex.row].pet.size = .middle
        
      } else {
        dogProfile[middleIndex.row].pet.size = .big
      }
    }
  }
  
  private var cellType: [State] = [.plus]
  private var dogProfile: [(pet: PetData, image: UIImage?)] = []
  private var visibleIndex: [IndexPath] = []
  private var clickedIndexPath: IndexPath?
  private var middleIndex: IndexPath = [0,0]
  private var tempImageUrl: String = ""
  private var weightList = [Double]()
  private var ageList = [Int]()
  private var newImage: UIImage?
  
  
  lazy var agePicker: UIPickerView = {
    let picker = UIPickerView()
    picker.delegate = self
    return picker
  }()
  
  lazy var weightPicker: UIPickerView = {
    let picker = UIPickerView()
    picker.delegate = self
    return picker
  }()
  
  
  @objc func didTaprepresentPetButton(_ sender: Any?) {
    if !representPetButton.isSelected {
      for i in dogProfile.indices{
        self.dogProfile[i].pet.isRepresent = false
      }
      self.dogProfile[middleIndex.row].pet.isRepresent = true
      print(self.dogProfile[middleIndex.row])
      representPetButton.isSelected = !representPetButton.isSelected
    }
  }
  
  private var typeText: String = "강아지" {
    didSet {
      petTypeButton.setTitle("\(typeText)", for: .normal)
      dogProfile[middleIndex.row].pet.type = petTypeButton.currentTitle ?? "강아지"
    }
  }
  
  @IBAction func didChangePetName(_ sender: Any) {
    dogProfile[middleIndex.row].pet.name = myPetNameTextField.text ?? ""
  }
  
  @IBAction func didChangePetAge(_ sender: Any) {
    if let age = petAgeTextField.text {
      dogProfile[middleIndex.row].pet.age = Int(age.components(separatedBy: "살")[0])
    } else {
      dogProfile[middleIndex.row].pet.age = nil
    }
  }
  
  @IBAction func didChangePetWeight(_ sender: Any) {
    if let weight = petWeightTextField.text {
      dogProfile[middleIndex.row].pet.weight = Double(weight.components(separatedBy: "살")[0])
    } else {
      dogProfile[middleIndex.row].pet.weight = nil
    }
  }
  
  @IBAction func didChangePetBreed(_ sender: Any) {
    dogProfile[middleIndex.row].pet.breed = petTypeTextField.text
  }
  
  @IBAction func didTapPetSizeButton(_ sender: UIButton) {
    self.showAlertController(style: UIAlertController.Style.actionSheet)
  }
  

  @IBAction func didTapPetTypeButton(_ sender: UIButton) {
    self.showAlertController(style: UIAlertController.Style.actionSheet, AlertList: ["강아지", "고양이"])
  }
  
  @IBAction func didTapRefreshButton(_ sender: UIButton) {
    clearForm()
  }
  
  @IBAction func didTapSaveButton(_ sender: UIButton) {
    guard let token = UserManager.shared.userIdandToken?.token, let userId = UserManager.shared.userIdandToken?.userId else {return}
    let profile = dogProfile[middleIndex.row]
    guard let name = profile.pet.name else {
      return}
    if profile.pet.id == "1" {
      // create
      APIService.shared.createPet(token: token, userId: userId, name: name, age: profile.pet.age, sex: profile.pet.sex, size: profile.pet.size, weight: profile.pet.weight, type: profile.pet.type, breed: profile.pet.breed, imageUrl: tempImageUrl , isRepresent: profile.pet.isRepresent) { [weak self](result) in
        guard let self = self else {return}
        switch result {
        case .success(let data):
          print(data)
          guard let newImage = self.newImage else {
            return
          }
          StorageService.shared.uploadImage(img: newImage, imageName: self.tempImageUrl)
        case .failure(let error):
          print(error)
        }
      }
    } else {
      if tempImageUrl == "" {
        APIService.shared.patchPetInfo(token: token, userId: userId, petId: profile.pet.id, name: name, age: profile.pet.age, sex: profile.pet.sex, size: profile.pet.size, weight: profile.pet.weight, type: profile.pet.type, breed: profile.pet.breed, imageUrl: nil, isRepresent: profile.pet.isRepresent) { (result) in
          switch result {
          case .success(let data):
            print(data)
          case .failure(let error):
            print(error)
          }
        }
      } else {
        APIService.shared.patchPetInfo(token: token, userId: userId, petId: profile.pet.id, name: name, age: profile.pet.age, sex: profile.pet.sex, size: profile.pet.size, weight: profile.pet.weight, type: profile.pet.type, breed: profile.pet.breed, imageUrl: tempImageUrl, isRepresent: profile.pet.isRepresent) { (result) in
          switch result {
          case .success(let data):
            print(data)
            guard let newImage = self.newImage else {
              return
            }
            StorageService.shared.uploadImage(img: newImage, imageName: self.tempImageUrl)
          case .failure(let error):
            print(error)
          }
        }
      }
    }
  }
  
  private func updateForm(cellType: String) {
    if cellType == "plus" {
     clearForm()
    } else {
      let data = dogProfile[middleIndex.row].pet
      myPetNameTextField.text = data.name
      petAgeTextField.text = "\(data.age ?? 0)살"
      petGenderSwitch.isOn = data.sex == Sex.male ? true : false
      petSizeButton.setTitle(data.size.rawValue, for: .normal)
      petWeightTextField.text = "\(data.weight ?? 0.0)KG"
      petTypeButton.setTitle(data.type, for: .normal)
      petTypeTextField.text = data.breed
      representPetButton.isSelected = data.isRepresent
    }
  }
  
  private func clearForm() {
    myPetNameTextField.text = nil
    petAgeTextField.text = nil
    petGenderSwitch.isOn = true
    petSizeButton.setTitle(Size.small.rawValue, for: .normal)
    petWeightTextField.text = nil
    petTypeButton.setTitle("강아지", for: .normal)
    petTypeTextField.text = nil
    representPetButton.isSelected = false
  }
  

  
  
  
  
}


//MARK: - PickerViewSetting

extension MyPetInfoEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  private func setPickerContents() {
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
  }
  
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
    //toorbar에 done올리기3
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

//MARK: - Set Keyboard
extension MyPetInfoEditViewController: UITextFieldDelegate {
  //index 오류를 막기 위해서 texfield focusing 될때 못바꾸게함
  func textFieldDidBeginEditing(_ textField: UITextField) {
    dogProfileCollectionView.isUserInteractionEnabled = false
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    dogProfileCollectionView.isUserInteractionEnabled = true
  }
  //return 키 누를 때 바로 됌
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
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
    
    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardWillShowNotification,
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
}

//MARK: - ImagePicker

extension MyPetInfoEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    var newImage: UIImage? = nil
    if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      newImage = originalImage
    }
    
    guard let newImage = newImage else {
      return}
    
    // 1. 이미지 변경
    self.dogProfile[self.middleIndex.row].image = newImage
    self.cellType[self.middleIndex.row] = .old
    guard let userId = UserManager.shared.userIdandToken?.userId else {return}
    
//    self.dogProfile[self.middleIndex.row].pet.imageUrl = "\(userId)_\(Date())"
    self.tempImageUrl = "\(userId)_\(Date())"
    self.newImage = newImage
    picker.dismiss(animated: true) {
      self.dogProfileCollectionView.reloadData()
    }
  }
}

//MARK: - CollectionView

extension MyPetInfoEditViewController: UICollectionViewDelegate, UICollectionViewDataSource, CarouselCellTapDelegate {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellType.count < 6 ? cellType.count : 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouseCell", for: indexPath) as? CaraouselCell else {
      return UICollectionViewCell()
    }
    
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longpressedCell(_:)))
    longPressGesture.minimumPressDuration = 1
    cell.addGestureRecognizer(longPressGesture)
    
    cell.dogImageView.isUserInteractionEnabled = true
    
    if cellType[indexPath.row] != .old {
      cell.dogImageView.image = UIImage(named: cellType[indexPath.row].rawValue)
    } else {
      if let image = self.dogProfile[indexPath.row].image {
        cell.dogImageView.image = image
      } else {
        cell.dogImageView.image = UIImage(named: State.camera.rawValue)
      }
    }
    setMiddleIndex(cell, indexPath: indexPath)
    
    //+버튼일 경우 다른 곳은 터치가 안되서 기입할 수가 없음
    if cellType[indexPath.row] == .plus && indexPath == middleIndex {
      isEditEnable(isOn: false)
    } else {
      isEditEnable(isOn: true)
    }
    
    if indexPath == middleIndex {
      updateForm(cellType: cellType[middleIndex.row].rawValue)
    }
    
    cell.delegate = self
    cell.selectedIndexPath = indexPath
    
    cell.dogImageView.layer.cornerRadius = cell.dogImageView.frame.size.height / 2
    cell.dogImageView.layer.masksToBounds = true
    cell.layer.cornerRadius = cell.frame.size.height / 2
    cell.layer.masksToBounds = true
    cell.dogImageView.clipsToBounds = true
    
    return cell
  }
  
  private func isEditEnable(isOn: Bool) {
    self.myPetNameTextField.isUserInteractionEnabled = isOn
    self.petTypeButton.isUserInteractionEnabled = isOn
    self.petTypeTextField.isUserInteractionEnabled = isOn
    self.petSizeButton.isUserInteractionEnabled = isOn
    self.petWeightTextField.isUserInteractionEnabled = isOn
    self.petAgeTextField.isUserInteractionEnabled = isOn
    self.petGenderSwitch.isUserInteractionEnabled = isOn
    self.representPetButton.isUserInteractionEnabled = isOn
  }
  
  @objc func longpressedCell(_ sender: UILongPressGestureRecognizer) {
    if sender.state == UIGestureRecognizer.State.began {
      let index = middleIndex.row
      if cellType[index] != .plus {
        let alert = UIAlertController(title: "프로필삭제", message: "입력한 정보를 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .default, handler: { [weak self] (action) in
          guard let self = self else {return}
          self.cellType.remove(at: index)
          self.dogProfile.remove(at: index)
          self.dogProfileCollectionView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
  
  // collectionView 초기화
  private func addCollectionView() {
    let layout = CarouselLayout()
    layout.itemSize = CGSize(width: dogProfileCollectionView.frame.size.width*0.5, height: dogProfileCollectionView.frame.size.height)
    layout.sideItemScale = 0.8
    layout.spacing = -50
    layout.isPagingEnabled = true
    layout.sideItemAlpha = 0.3
    
    dogProfileCollectionView.collectionViewLayout = layout
    
    self.dogProfileCollectionView?.delegate = self
    self.dogProfileCollectionView?.dataSource = self
    
    self.dogProfileCollectionView.register(CaraouselCell.self, forCellWithReuseIdentifier: "carouseCell")
    self.dogProfileCollectionView.showsHorizontalScrollIndicator = false
  }
  
  //scroll이 끝나면 해야할일
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    visibleCell()
    dogProfileCollectionView.reloadData()
  }
  
  //가운데 인덱스 구하기
  private func setMiddleIndex(_ cell: UICollectionViewCell, indexPath: IndexPath) {
    if cell.alpha > 0.9 {
      middleIndex = indexPath
    }
  }
  
  private func visibleCell() {
    var indexArray: [IndexPath] = []
    for cell in dogProfileCollectionView.visibleCells {
      guard let indexPath = dogProfileCollectionView.indexPath(for: cell) else {
        return
      }
      indexArray.append(indexPath)
    }
    visibleIndex = indexArray
  }
  
  //MARK: - Delegate

  func didTapImageView(indexPath: IndexPath?) {
    
    if let indexPath = indexPath {
      if cellType[indexPath.row] == .plus && dogProfileCollectionView.cellForItem(at: indexPath)?.alpha ?? 0.8 > 0.9 {
        cellType.insert(.camera, at: cellType.count - 1)
        dogProfile.append((PetData(id: "1", sex: .male, type: "강아지", size: .small, isRepresent: false), nil))
      } else if cellType[indexPath.row] == .camera && dogProfileCollectionView.cellForItem(at: indexPath)?.alpha ?? 0.8 > 0.9 {
        let myPetImagePickerController: UIImagePickerController = UIImagePickerController()
        myPetImagePickerController.allowsEditing = true
        myPetImagePickerController.delegate = self
        present(myPetImagePickerController, animated: true)
      } else if cellType[indexPath.row] == .old && dogProfileCollectionView.cellForItem(at: indexPath)?.alpha ?? 0.8 > 0.9 {
        let myPetImagePickerController: UIImagePickerController = UIImagePickerController()
        myPetImagePickerController.allowsEditing = true
        myPetImagePickerController.delegate = self
        present(myPetImagePickerController, animated: true)
      } else {
        return
      }
      dogProfileCollectionView.reloadData()
    }
  }
}

extension MyPetInfoEditViewController: JJollaeButtonDelegate {
  func isOnValueChage(isOn: Bool) {
    if cellType[middleIndex.row] != .plus {
      if isOn == true {
        dogProfile[middleIndex.row].pet.sex = .male
      } else {
        dogProfile[middleIndex.row].pet.sex = .female
      }
    }
  }
}

//MARK: - Actionsheet

extension MyPetInfoEditViewController {
  private func showAlertController(style: UIAlertController.Style) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    let bigSizeAction = UIAlertAction(title: "대형", style: .default) { [weak self]
      result in self?.sizeText = "대형"
    }
    let middleSizeAction = UIAlertAction(title: "중형", style: .default) {
      [weak self] result in self?.sizeText = "중형"
    }
    let smallSizeAction = UIAlertAction(title: "소형", style: .default) { [weak self] result in
      self?.sizeText = "소형"
    }
    actionsheetUI(alertController: alertController)
    alertController.addAction(bigSizeAction)
    alertController.addAction(middleSizeAction)
    alertController.addAction(smallSizeAction)
    alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    self.present(alertController, animated: true, completion: nil);
  }
  
  private func showAlertController(style: UIAlertController.Style, AlertList: [String]) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    AlertList.forEach { (type) in
      alertController.addAction(UIAlertAction(title: type, style: .default) { [weak self] result in
        self?.typeText = type
      })
    }
    actionsheetUI(alertController: alertController)
    alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    self.present(alertController, animated: true, completion: nil);
  }
  
  private func actionsheetUI(alertController: UIAlertController){
    let subview = alertController.view.mainView! as UIView
    let alertContentView = subview.mainView! as UIView
    alertContentView.setRounded(radius: 10)
    alertContentView.overrideUserInterfaceStyle = .light
    alertContentView.backgroundColor = UIColor.white
    alertController.view.setRounded(radius: 10)
    alertController.view.tintColor = .themeGreen
  }
}

