//
//  MyInfoDetailViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/03.
//

import UIKit

class MyInfoDetailViewController: UIViewController, StoryboardInstantiable, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var profileCollectionView: UICollectionView!
  @IBOutlet weak var infoSegmentedControl: UISegmentedControl! {
    didSet {
      infoSegmentedControl.removeBorder()
      infoSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.themeGreen, NSAttributedString.Key.font: UIFont.robotoBold(size: 16)], for: .selected)
      infoSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray03, NSAttributedString.Key.font : UIFont.robotoMedium(size: 16)], for: .normal)
      infoSegmentedControl.addBorder([.bottom], color: .gray05, width: 1)
    }
  }
  
  @IBOutlet weak var saveButton: UIButton! {
    didSet {
      saveButton.backgroundColor = .themeGreen
      saveButton.setTitleColor(.white, for: .normal)
      saveButton.setRounded(radius: 10)
    }
  }
  @IBOutlet weak var refreshButton: UIButton! {
    didSet {
      refreshButton.titleLabel?.font = .robotoMedium(size: 14)
      refreshButton.setTitleColor(.gray03, for: .normal)
    }
  }
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  private var UserInfo: UserData? {
    didSet {
      
    }
  }
  var profileImage:[Data] = []
  var dogProfileImages: [String] = []
  private var visibleIndex: [IndexPath] = []
  private var middleIndex: IndexPath = [0,0]
  private var originY:CGFloat = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(getpageIndex(_:)), name: NSNotification.Name("SegControlNotification"), object: nil)
    setKeyboard()
    profileCollectionView.delegate = self
    profileCollectionView.dataSource = self
    self.tabBarController?.tabBar.isHidden = true
    self.tabBarController?.tabBar.isTranslucent = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.isHidden = false
    self.tabBarController?.tabBar.isTranslucent = false
  }
}
//MARK: - IBACTION & OBJC

extension MyInfoDetailViewController {
  
  @objc func getpageIndex(_ notification: Notification) {
    var getValue = notification.object as! Int
    print(getValue)
    if getValue < 0 {
      getValue = 0
    } else if getValue >= 2 {
      getValue = 1
    }
    infoSegmentedControl.selectedSegmentIndex = getValue
    profileCollectionView.reloadData()
  }
  
  @IBAction func didTapInfoSegmentedControl(_ sender: UISegmentedControl) {
    //여기도 노티를 보내긴해야함
    NotificationCenter.default.post(name: NSNotification.Name("PageControlNotification"), object: infoSegmentedControl.selectedSegmentIndex)
    profileCollectionView.reloadData()
  }
  
  @IBAction func didTapSaveButton(_ sender: UIButton) {
    //TODO: 데이터는 infodetailvc에서 관리하고 있기 때문에, 일단 눌렀을때, 2
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}
  



//MARK: - collectionview, imagepicker

extension MyInfoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, CarouselCellTapDelegate {
  func didTapImageView(indexPath: IndexPath?) {
    if let indexPath = indexPath {
      if dogProfileImages[indexPath.row] == "plus" && profileCollectionView.cellForItem(at: indexPath)?.alpha ?? 0.8 > 0.9 {
        dogProfileImages.insert("camera", at: dogProfileImages.count - 1)
        
//        dogProfile.append(PetInfo())
      } else if dogProfileImages[indexPath.row] == "camera" && profileCollectionView.cellForItem(at: indexPath)?.alpha ?? 0.8 > 0.9 {
        let myPetImagePickerController: UIImagePickerController = UIImagePickerController()
        myPetImagePickerController.allowsEditing = true
        myPetImagePickerController.delegate = self
        present(myPetImagePickerController, animated: true)
      } else if dogProfileImages[indexPath.row] == "old" && profileCollectionView.cellForItem(at: indexPath)?.alpha ?? 0.8 > 0.9 {
        let myPetImagePickerController: UIImagePickerController = UIImagePickerController()
        myPetImagePickerController.allowsEditing = true
        myPetImagePickerController.delegate = self
        present(myPetImagePickerController, animated: true)
      } else {
        return
      }
      profileCollectionView.reloadData()
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if infoSegmentedControl.selectedSegmentIndex == 0 {
      return self.profileImage.count
    } else {
      return self.dogProfileImages.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouseCell", for: indexPath) as? CaraouselCell else {
      return UICollectionViewCell()
    }
    cell.dogImageView.isUserInteractionEnabled = true
    if infoSegmentedControl.selectedSegmentIndex == 0 {
      cell.dogImageView.image = UIImage(data: profileImage[indexPath.row])
    } else {
      //TODO: 어떻게 넣을지 정해야함
      
    }
    return cell
  }
  
  private func addCollectionView() {
    let layout = CarouselLayout()
    layout.itemSize = CGSize(width: profileCollectionView.frame.size.width*0.796, height: profileCollectionView.frame.size.height)
    layout.sideItemScale = 1/3
    layout.spacing = -100
    layout.isPagingEnabled = true
    layout.sideItemAlpha = 0.5
    
    profileCollectionView.collectionViewLayout = layout
    
    self.profileCollectionView?.delegate = self
    self.profileCollectionView?.dataSource = self
    
    self.profileCollectionView.register(CaraouselCell.self, forCellWithReuseIdentifier: "carouseCell")
    self.profileCollectionView.showsHorizontalScrollIndicator = false
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    visibleCell()
    profileCollectionView.reloadData()
  }
  
  //가운데 인덱스 구하기
  func setMiddleIndex(_ cell: UICollectionViewCell, indexPath: IndexPath) {
    if cell.alpha > 0.9 {
      middleIndex = indexPath
    }
  }
  
  func visibleCell() {
    var indexArray: [IndexPath] = []
    for cell in profileCollectionView.visibleCells {
      guard let indexPath = profileCollectionView.indexPath(for: cell) else {
        return
      }
      indexArray.append(indexPath)
    }
    visibleIndex = indexArray
  }
  
  private func updateForm(cellType: String) {
    if cellType == "plus" {
     clearForm()
    } else {
      //TODO: pagingvc와 연결된 곳과 notification 쓰자 데이터를 그러면 DetailVC에서 가지고 있다가 넘겨주면 그에 맞춰서
//      let data = dogProfile[middleIndex.row]
//      myPetNameTextField.text = data.name
//      petAgeTextField.text = "\(data.age ?? 0)살"
//      petGenderSwitch.isOn = data.sex == Gender.male ? true : false
//      petSizeButton.setTitle(data.size.rawValue, for: .normal)
//      petWeightTextField.text = "\(data.weight ?? 0.0)KG"
//      petTypeButton.setTitle(data.type, for: .normal)
//      petTypeTextField.text = data.breed
    }
  }
  
  private func clearForm() {
//    myPetNameTextField.text = nil
//    petAgeTextField.text = nil
//    petGenderSwitch.isOn = true
//    petSizeButton.setTitle(Size.small.rawValue, for: .normal)
//    petWeightTextField.text = nil
//    petTypeButton.setTitle("강아지", for: .normal)
//    petTypeTextField.text = nil
    
  }
  
}

//MARK: - Keyboard

extension MyInfoDetailViewController {


  private func setKeyboard() {
    
    let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    
    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { (notification) in
      guard let userInfo = notification.userInfo else { return }
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
        let x = self.containerView.frame.origin.x
        let y = self.containerView.frame.origin.y
        let height = self.containerView.frame.size.height
        let width = self.containerView.frame.size.width
      self.scrollView.scrollRectToVisible(CGRect(x: x, y: y, width: width, height: height), animated: true)
      guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
      UIView.animate(withDuration: duration) {
        self.view.layoutIfNeeded()
      }
    }
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { (notification) in
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
