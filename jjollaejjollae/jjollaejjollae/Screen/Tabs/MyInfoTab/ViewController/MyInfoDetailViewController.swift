//
//  MyInfoDetailViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/03.
//

import UIKit

protocol ControlChildViewControllerDelegate: NSObject {
  func cleanContents(_ collectionView: UICollectionView)
  func enableEditing(_ collectionView: UICollectionView)
  func disableEditing(_ collectionView: UICollectionView)
  func DidEnterMiddleIndex(_ collectionView: UICollectionView, dogProfile: PetData)
}

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
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  private var userInfo: UserData?
  weak var delegate: ControlChildViewControllerDelegate?
  private var dogTuples: [(petdata: PetData, image: UIImage?)] = []
  private var representDogImageUrl: String? = "default.jpeg"
  private var representDogImage: UIImage?
  private var dogLimit = 5
  private var visibleIndex: [IndexPath] = []
  private var middleIndex: IndexPath = [0,0]
  lazy var defaultImageData = UIImage(named: "IMG_4930")?.jpegData(compressionQuality: 0.1)
  lazy var cameraImage = UIImage(named: "camera")
  lazy var plusImage = UIImage(named: "plus")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userInfo = UserManager.shared.userInfo
    NotificationCenter.default.addObserver(self, selector: #selector(getpageIndex(_:)),
                                           name: NSNotification.Name("SegControlNotification"),
                                           object: nil)
    setKeyboard()
    setupImageArray()
    addCollectionView()
    findRepresentDogImageUrl()
  }
  
  // 대표갱얼쥐 찾기
  private func findRepresentDogImageUrl() {
    if dogTuples.count < 1 {return}
    var index = 0
    for i in dogTuples.indices {
      if dogTuples[i].petdata.isRepresent {
        index = i
        break
      }
    }
    representDogImageUrl = dogTuples[index].petdata.imageUrl
  }
  
  //1. 유저가 변경할 수 있는 이미지는 캐시에 두지 않는다.
  private func setupImageArray() {
    guard let userInfo = UserManager.shared.userInfo else {
      fatalError("유저정보를 불러올수가 없습니다.")
    }
    for pet in userInfo.pets {
      dogTuples.append((pet, nil))
    }
    for index in dogTuples.indices {
      if let petImageUrl = dogTuples[index].petdata.imageUrl {
        StorageService.shared.downloadUIImageWithURL(with: petImageUrl, imageCompletion: { [weak self] (image) in
          guard let self = self else {return}
          if let image = image {
            print("이미지 존재😊")
            self.dogTuples[index].image = image
          } else {
            print("이미지 없음🥲")
            self.dogTuples[index].image = UIImage(data: self.defaultImageData!)!
          }
        })
      } else {
        self.dogTuples[index].petdata.imageUrl = nil
        self.dogTuples[index].image = cameraImage
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
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

// imageURl = nil 이면 사진이 없는애(카메라사진), imageURl은 없는애는 이미지를 못불어온애(기본이미지)


//MARK: - collectionview, imagepicker

extension MyInfoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, CarouselCellTapDelegate {
  
  func didTapImageView(indexPath: IndexPath?) {
    if let indexPath = indexPath {
      if profileCollectionView.cellForItem(at: indexPath)?.alpha ?? 0.8 > 0.9 {
        switch dogTuples[indexPath.row].petdata.imageUrl {
        case "plus":
          dogTuples.insert((PetData(id: "1", sex: .male, name: "쫄래쫄래", type: "강아지", size: .small, isRepresent: false), plusImage), at: dogTuples.count - 1)
        case nil:
          let myPetImagePickerController: UIImagePickerController = UIImagePickerController()
          myPetImagePickerController.allowsEditing = true
          myPetImagePickerController.delegate = self
          present(myPetImagePickerController, animated: true)
        default:
          let myPetImagePickerController: UIImagePickerController = UIImagePickerController()
          myPetImagePickerController.allowsEditing = true
          myPetImagePickerController.delegate = self
          present(myPetImagePickerController, animated: true)
        }
        profileCollectionView.reloadData()
      }
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if infoSegmentedControl.selectedSegmentIndex == 0 {
      return 1
    } else {
      return self.dogTuples.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouseCell", for: indexPath) as? CaraouselCell else {
      return UICollectionViewCell()
    }
    cell.dogImageView.isUserInteractionEnabled = true
    if infoSegmentedControl.selectedSegmentIndex == 0 {
      cell.dogImageView.setImage(with: self.representDogImageUrl ?? "default")
    } else {
      let image = dogTuples[indexPath.row].image
      cell.dogImageView.image = image ?? UIImage(data: self.defaultImageData!)!
    }
    
    cell.dogImageView.isUserInteractionEnabled = true
    setMiddleIndex(cell, indexPath: indexPath)
    
    if indexPath == middleIndex {
      if dogTuples[indexPath.row].image == plusImage {
        delegate?.disableEditing(profileCollectionView)
      } else {
        delegate?.enableEditing(profileCollectionView)
        updateForm(dogImageUrl: dogTuples[middleIndex.row].petdata.imageUrl)
      }
    }
    
    cell.delegate = self
    cell.selectedIndexPath = indexPath
    return cell
  }
  
  private func addCollectionView() {
    let layout = CarouselLayout()
    layout.itemSize = CGSize(width: profileCollectionView.frame.size.width*0.796, height: profileCollectionView.frame.size.height)
    layout.sideItemScale = 1/3
    layout.spacing = -150
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
  
  private func updateForm(dogImageUrl: String?) {
    if dogImageUrl == "plus" {
      delegate?.cleanContents(profileCollectionView)
    } else {
      delegate?.DidEnterMiddleIndex(profileCollectionView, dogProfile: dogTuples[middleIndex.row].petdata)
    }
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
        let PetVCButtonViewHeight:CGFloat = 105
        if self.infoSegmentedControl.selectedSegmentIndex == 0 && self.userInfo?.accountType.rawValue == "social" {
          self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height / 2, right: 0)
          self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height / 2, right: 0)
        } else {
          self.scrollView.contentInset = contentInset
          self.scrollView.scrollIndicatorInsets = contentInset
          let x = self.containerView.frame.origin.x
          let y = self.containerView.frame.origin.y
          let height = self.containerView.frame.size.height
          let width = self.containerView.frame.size.width
          self.scrollView.scrollRectToVisible(CGRect(x: x, y: y, width: width, height: height - PetVCButtonViewHeight), animated: true)
        }
        
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
