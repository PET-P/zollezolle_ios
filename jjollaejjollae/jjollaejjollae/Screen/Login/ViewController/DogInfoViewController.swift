//
//  DogInfoViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/08.
//

import UIKit
import PhotosUI

class FixModalViewController: UIViewController {
  override func viewDidLoad() {
    self.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 10);
  }
}

class DogInfoViewController: FixModalViewController {
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
  
  @IBOutlet weak var myPetNameTextField: UITextField! {
    didSet {
      myPetNameTextField.setRounded(radius: nil)
      myPetNameTextField.backgroundColor = .themePaleGreen
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
      petAgeTextField.layer.borderColor = UIColor.themePaleGreen.cgColor
      petAgeTextField.font = .robotoMedium(size: 16)
      petAgeTextField.placeholder = "4살"
      petAgeTextField.textColor = UIColor.gray01
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
      petSizeButton.layer.borderColor = UIColor.themePaleGreen.cgColor
      petSizeButton.layer.borderWidth = 1
      petSizeButton.setTitle("소형", for: .normal)
      petSizeButton.tintColor = UIColor.gray01
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
      petWeightTextField.layer.borderColor = UIColor.themePaleGreen.cgColor
      petWeightTextField.font = .robotoMedium(size: 16)
      petWeightTextField.textColor = UIColor.gray01
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
      petTypeButton.layer.borderColor = UIColor.themePaleGreen.cgColor
      petTypeButton.layer.borderWidth = 1
      petTypeButton.setTitle("강아지", for: .normal)
      petTypeButton.tintColor = UIColor.gray01
      petTypeButton.titleLabel?.font = .robotoMedium(size: 16)
    }
  }
  
  @IBOutlet weak var petTypeTextField: UITextField! {
    didSet {
      petTypeTextField.placeholder = "아기의 품종을 써주세요!"
      petTypeTextField.layer.borderWidth = 1
      petTypeTextField.layer.borderColor = UIColor.themePaleGreen.cgColor
      petTypeTextField.font = .robotoMedium(size: 16)
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
      saveButton.setRounded(radius: 25)
      saveButton.backgroundColor = UIColor.themeGreen
    }
  }
  @IBOutlet weak var ContinueWithoutSaveButton: UIButton! {
    didSet {
      ContinueWithoutSaveButton.setTitle("맞춤정보 없이 둘러보기", for: .normal)
      ContinueWithoutSaveButton.titleLabel?.textColor = UIColor.gray04
      ContinueWithoutSaveButton.tintColor = UIColor.gray04
      ContinueWithoutSaveButton.backgroundColor = .none
      ContinueWithoutSaveButton.layer.borderWidth = 0
    }
  }
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var dogProfileCollectionView: dogInfoCollectionView!
  
  //MARK: - Variables
  
  private let imagePickerController: UIImagePickerController = UIImagePickerController()
  
  private var sizeText: String = "소형" {
    didSet {
      petSizeButton.setTitle("\(sizeText)", for: .normal)
      if petSizeButton.currentTitle == "소형" {
        dogProfile[middleIndex.row].size = .small
      } else if petSizeButton.currentTitle == "중형" {
        dogProfile[middleIndex.row].size = .middle
      } else {
        dogProfile[middleIndex.row].size = .big
      }
    }
  }

  private var cellType: [String] = ["camera", "plus"]
  private var dogProfile: [DogInfo] = []
  private var visibleIndex: [IndexPath] = []
  private var clickedIndexPath: IndexPath?
  private var images: [UIImage?] = []
  private var middleIndex: IndexPath = [0,0]
  
  //MARK: - View LifeCycle
  
  private lazy var dogInfoManager = DogInfoManager()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setKeyboard()
    myPetNameTextField.addTarget(self, action: #selector(didChangePetName(_:)), for: .editingDidEnd)
    petAgeTextField.addTarget(self, action: #selector(didChangePetAge(_:)), for: .editingDidEnd)
    petWeightTextField.addTarget(self, action: #selector(didChangePetWeight(_:)), for: .editingDidEnd)
    petTypeTextField.addTarget(self, action: #selector(didChangePetTypeName(_:)), for: .editingDidEnd)
    petGenderSwitch.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    addCollectionView()
    // TODO: Userdata에서 가져오기
    setUpDogProfile()
  }
  
  private func setUpDogProfile() {
    dogProfile = dogInfoManager.dogInfos
    var tempCellType: [String] = []
    if dogInfoManager.isDogInfosEmpty {
      // dogprofile에 아무것도 없으면?? 처음들어가는 상황
      print("1번?")
      tempCellType = ["camera", "plus"]
      dogProfile = [DogInfo()]
    } else {
      // dogprofile에 처음들어가는 상황이 아님
      print("2번?")
      for i in dogProfile.indices {
        // 이미지 설정이 되어있지 않다면?
        if dogProfile[i].imageData == nil {
          tempCellType.append("camera")
        } else { //이미지설정이 되어있다면?
          tempCellType.append("old")
        }
      }
      //마지막은 plus로 마무리
      tempCellType.append("plus")
    }
    cellType = tempCellType
  }
  
  //MARK: - Functions
  
  private var typeText: String = "강아지" {
    didSet {
      petTypeButton.setTitle("\(typeText)", for: .normal)
      dogProfile[middleIndex.row].type = petTypeButton.currentTitle ?? "강아지"
    }
  }
  
  @objc private func didChangePetName(_ sender: Any?) {
    dogProfile[middleIndex.row].name = myPetNameTextField.text
  }
  
  @objc private func didChangePetAge(_ sender: Any?) {
    dogProfile[middleIndex.row].age = petAgeTextField.text
  }
  
  @objc private func didChangePetWeight(_ sender: Any?) {
    dogProfile[middleIndex.row].name = petWeightTextField.text
  }
  
  @objc private func didChangePetTypeName(_ sender: Any?){
    dogProfile[middleIndex.row].typeName = petTypeTextField.text
  }
  
  
  
  @IBAction private func didTapContinueWithoutSaveButton(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
    let homeStoryboard = UIStoryboard(name: "HomeMain", bundle: nil)
    guard let homeVC = homeStoryboard.instantiateViewController(identifier: "HomeMainViewController") as? HomeMainViewController else {
      return
    }
    self.navigationController?.pushViewController(homeVC, animated: true)
  }
  
  @IBAction func didTapPetSizeButton(_ sender: UIButton) {
    self.showAlertController(style: UIAlertController.Style.actionSheet)
  }
  
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
      alertController.addAction(UIAlertAction(title: type, style: .default) { [weak self] result in
        self?.typeText = type
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
  
  @IBAction func didTapSaveButton(_ sender: UIButton) {
    var flag = false
    dogProfile.forEach { dogInfo in
      if dogInfo.name == nil {
        let alertController = UIAlertController(title: nil, message: "이름을 입력하개", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.setRounded(radius: 10)
        alertContentView.overrideUserInterfaceStyle = .light
        alertContentView.backgroundColor = UIColor.white
        alertController.view.setRounded(radius: 10)
        alertController.view.tintColor = .themeGreen
        self.present(alertController, animated: true, completion: nil)
        return
      } else {
        flag = true
      }
    }
    if flag {
      dogInfoManager.dogInfos = dogProfile
    }
  }
  
  private func updateForm(cellType: String) {
    if cellType == "plus" {
     clearForm()
    } else {
      let data = dogProfile[middleIndex.row]
      myPetNameTextField.text = data.name
      petAgeTextField.text = data.age
      petGenderSwitch.isOn = data.gender.rawValue == 1 ? true : false
      petSizeButton.setTitle(data.size.rawValue, for: .normal)
      petWeightTextField.text = data.weight
      petTypeButton.setTitle(data.type, for: .normal)
      petTypeTextField.text = data.typeName
    }
  }
  
  private func clearForm() {
    myPetNameTextField.text = nil
    petAgeTextField.text = nil
    petGenderSwitch.isOn = true
    petSizeButton.setTitle(DogInfo.Size.small.rawValue, for: .normal)
    petWeightTextField.text = nil
    petTypeButton.setTitle("강아지", for: .normal)
    petTypeTextField.text = nil
    
  }
  
}

extension DogInfoViewController: UITextFieldDelegate {
  //MARK: - Keyboard
  
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
      self.dogProfile[middleIndex.row].imageData = originalImage.jpegData(compressionQuality: 0.1)
      self.cellType[self.middleIndex.row] = "old"
      //TODO: 이미지 저장할 모델링
      //TODO: 정한 이미지 pan gesture
    }
    self.dismiss(animated: true) {
      self.dogProfileCollectionView.reloadData()
    }
  }
}

//MARK: - CollectionView

extension DogInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate, CarouselCellTapDelegate {
 
  //MARK: - DataSource
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellType.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouseCell", for: indexPath) as? CaraouselCell else {
      return UICollectionViewCell()
    }
    cell.dogImageView.isUserInteractionEnabled = true
    if cellType[indexPath.row] == "camera" {
      cell.dogImageView.image = UIImage(named: "camera")
    }
    else if cellType[indexPath.row] == "plus" {
      cell.dogImageView.image = UIImage(named: "plus")
    }
    else {
      if let data = self.dogProfile[indexPath.row].imageData {
        cell.dogImageView.image = UIImage(data: data)
      } else {
        cell.dogImageView.image = UIImage(named: "camera")
      }
    }
    setMiddleIndex(cell, indexPath: indexPath)
    
    //+버튼일 경우 다른 곳은 터치가 안되서 기입할 수가 없음
    if cellType[indexPath.row] == "plus" && indexPath == middleIndex {
      self.myPetNameTextField.isUserInteractionEnabled = false
      self.petTypeButton.isUserInteractionEnabled = false
      self.petTypeTextField.isUserInteractionEnabled = false
      self.petSizeButton.isUserInteractionEnabled = false
      self.petWeightTextField.isUserInteractionEnabled = false
      self.petAgeTextField.isUserInteractionEnabled = false
      self.petGenderSwitch.isUserInteractionEnabled = false
    } else {
      self.myPetNameTextField.isUserInteractionEnabled = true
      self.petTypeButton.isUserInteractionEnabled = true
      self.petTypeTextField.isUserInteractionEnabled = true
      self.petSizeButton.isUserInteractionEnabled = true
      self.petWeightTextField.isUserInteractionEnabled = true
      self.petAgeTextField.isUserInteractionEnabled = true
      self.petGenderSwitch.isUserInteractionEnabled = true
    }
    
    if indexPath == middleIndex {
      updateForm(cellType: cellType[middleIndex.row])
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
  
  //MARK: - Functions
  
  // collectionView 초기화
  private func addCollectionView() {
    let layout = CarouselLayout()
    layout.itemSize = CGSize(width: dogProfileCollectionView.frame.size.width*0.796, height: dogProfileCollectionView.frame.size.height)
    layout.sideItemScale = 1/3
    layout.spacing = -100
    layout.isPagingEnabled = true
    layout.sideItemAlpha = 0.5
    
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
  func setMiddleIndex(_ cell: UICollectionViewCell, indexPath: IndexPath) {
    if cell.alpha > 0.9 {
      middleIndex = indexPath
    }
  }
  
  func visibleCell() {
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
      if cellType[indexPath.row] == "plus" && dogProfileCollectionView.cellForItem(at: indexPath)?.alpha ?? 0.8 > 0.9 {
        cellType.insert("camera", at: cellType.count - 1)
        
        dogProfile.append(DogInfo())
      } else if cellType[indexPath.row] == "camera" && dogProfileCollectionView.cellForItem(at: indexPath)?.alpha ?? 0.8 > 0.9 {
        let myPetImagePickerController: UIImagePickerController = UIImagePickerController()
        myPetImagePickerController.allowsEditing = true
        myPetImagePickerController.delegate = self
        present(myPetImagePickerController, animated: true)
      } else if cellType[indexPath.row] == "old" && dogProfileCollectionView.cellForItem(at: indexPath)?.alpha ?? 0.8 > 0.9 {
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

extension DogInfoViewController: JJollaeButtonDelegate {
  func isOnValueChage(isOn: Bool) {
    if cellType[middleIndex.row] != "plus" {
      if isOn == true {
        dogProfile[middleIndex.row].gender = .male
      } else {
        dogProfile[middleIndex.row].gender = .female
      }
    }
  }
}


