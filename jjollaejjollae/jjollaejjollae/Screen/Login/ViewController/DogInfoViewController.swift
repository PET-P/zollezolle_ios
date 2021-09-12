//
//  DogInfoViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/08.
//

import UIKit


class dogInfoCollectionView: UICollectionView {
  // reloadData 이후에 일어날 일
  private var reloadDataCompletionBlock: (() -> Void)?
  
  private var findCenterBlock: (()->Void)?
  
  
  
  func reloadDataWithCompletion(_ complete: @escaping () -> Void) {
    reloadDataCompletionBlock = complete
    super.reloadData()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if let block = reloadDataCompletionBlock {
      block()
    }
  }
}

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
      petAgeTextField.textColor = UIColor.쫄래블랙
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
      petSizeButton.tintColor = UIColor.쫄래블랙
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
      petWeightTextField.textColor = UIColor.쫄래블랙
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
      petTypeButton.layer.borderColor = UIColor.쫄래페일그린.cgColor
      petTypeButton.layer.borderWidth = 1
      petTypeButton.setTitle("강아지", for: .normal)
      petTypeButton.tintColor = UIColor.쫄래블랙
      petTypeButton.titleLabel?.font = .robotoMedium(size: 16)
    }
  }

  @IBOutlet weak var petTypeTextField: UITextField! {
    didSet {
      petTypeTextField.placeholder = "아기의 품종을 써주세요!"
      petTypeTextField.layer.borderWidth = 1
      petTypeTextField.layer.borderColor = UIColor.쫄래페일그린.cgColor
      petTypeTextField.font = .robotoMedium(size: 16)
      petTypeTextField.textColor = UIColor.쫄래블랙
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
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var dogProfileCollectionView: dogInfoCollectionView!
  
  //MARK: - Variables

  
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
  
  private var dogProfile: [String] = ["camera", "plus"]
  private var visibleIndex: [IndexPath] = []
  private var clickedIndexPath: IndexPath?
  private var images: [UIImage] = []
  
  //MARK: - View LifeCycle

  
  override func viewDidLoad() {
    super.viewDidLoad()
    setKeyboard()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    addCollectionView()
  }
  
  //MARK: - Functions

  @IBAction private func didTapContinueWithoutSaveButton(_ sender: UIButton) {
    
  }
  
  @IBAction func didTapPetSizeButton(_ sender: UIButton) {
    self.showAlertController(style: UIAlertController.Style.actionSheet)
  }
  
  private func showAlertController(style: UIAlertController.Style) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    let bigSizeAction = UIAlertAction(title: "대형", style: .default) { result in self.sizeText = "대형"
    }
    let middleSizeAction = UIAlertAction(title: "중형", style: .default) { result in self.sizeText = "중형"
    }
    let smallSizeAction = UIAlertAction(title: "소형", style: .default) { result in
      self.sizeText = "소형"
    }
    let subview = alertController.view.subviews.first! as UIView
    let alertContentView = subview.subviews.first! as UIView
    alertContentView.setRounded(radius: 10)
    alertContentView.overrideUserInterfaceStyle = .light
    alertContentView.backgroundColor = UIColor.white
    alertController.view.setRounded(radius: 10)
    alertController.view.tintColor = .쫄래그린
    alertController.addAction(bigSizeAction)
    alertController.addAction(middleSizeAction)
    alertController.addAction(smallSizeAction)
    alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    self.present(alertController, animated: true, completion: nil);
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
    guard let clickedIndexPath = self.clickedIndexPath else {return}
    if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      images.append(originalImage)
      self.dogProfile[clickedIndexPath.row] = "old"
      //TODO: 이미지 저장할 모델링
      //TODO: 정한 이미지 pan gesture
    }
    self.dismiss(animated: true) {
      self.dogProfileCollectionView.scrollToItem(at: clickedIndexPath, at: .centeredHorizontally, animated: true)
      self.dogProfileCollectionView.reloadData()
    }
  }
}

//MARK: - CollectionView

extension DogInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate, CarouselCellTapDelegate {
  
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
  //MARK: - DataSource

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dogProfile.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouseCell", for: indexPath) as? CaraouselCell else {
      return UICollectionViewCell()
    }
    print(dogProfile)
    cell.dogImageView.isUserInteractionEnabled = true
    if dogProfile[indexPath.row] == "camera" {
      cell.dogImageView.image = UIImage(named: "camera")

    }
    else if dogProfile[indexPath.row] == "plus" {
      cell.dogImageView.image = UIImage(named: "plus")
    }
    else {
      cell.dogImageView.image = images[indexPath.row]
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
  
  //scroll이 끝나면 해야할일
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    visibleCell()
    dogProfileCollectionView.reloadData()
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
    print(visibleIndex)
  }
  
  //MARK: - Delegate
  
  func didTapImageView(indexPath: IndexPath?) {
    
    if let indexPath = indexPath {
      print(dogProfile[indexPath.row])
      if indexPath.row == dogProfile.count - 1 && visibleIndex.count == 2 && dogProfile[indexPath.row] == "plus"{
        print("\(dogProfile[indexPath.row]), \(indexPath)")
        dogProfile.insert("camera", at: dogProfile.count - 1)
      }
      else if dogProfile[indexPath.row] == "camera" && visibleIndex.count == 3 && visibleIndex[1] == indexPath || visibleIndex.count == 0 && dogProfile[indexPath.row] == "camera" || visibleIndex.count == 2 && dogProfile[indexPath.row] == "camera"{ //이미지 피커 부르자
        print("사진")
        let myPetImagePickerController: UIImagePickerController = UIImagePickerController()
        myPetImagePickerController.allowsEditing = true
        myPetImagePickerController.delegate = self
        present(myPetImagePickerController, animated: true) {
          self.clickedIndexPath = indexPath
        }
      } else if dogProfile[indexPath.row] == "old" && visibleIndex.count == 3 && visibleIndex[1] == indexPath || visibleIndex.count == 0 && dogProfile[indexPath.row] == "old" || visibleIndex.count == 2 && dogProfile[indexPath.row] == "old" {
        print("다시")
        let myPetImagePickerController: UIImagePickerController = UIImagePickerController()
        myPetImagePickerController.allowsEditing = true
        myPetImagePickerController.delegate = self
        present(myPetImagePickerController, animated: true) {
          self.clickedIndexPath = indexPath
        }
      }
      dogProfileCollectionView.reloadDataWithCompletion {
        self.visibleCell()
      }
    }
  }
}


