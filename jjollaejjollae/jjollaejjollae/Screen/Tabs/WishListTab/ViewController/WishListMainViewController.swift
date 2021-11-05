//
//  WishListMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit
import os_workgroup
import KakaoSDKAuth

enum WishListMode {
  case fromCell
  case fromTab
}

class WishlistMainViewController: UIViewController {
  
  @IBOutlet weak var closeButton: UIButton!
  
  @IBOutlet weak var addWishlistButton: UIButton! {
    didSet {
      applyDesign(to: addWishlistButton)
    }
  }
  
  @IBOutlet weak var wishListInfoLabel: UILabel!
  
  @IBOutlet weak var wishlistCollectionView: UICollectionView! {
    didSet {
      wishlistCollectionView.dataSource = self
      wishlistCollectionView.delegate = self
      wishlistCollectionView.showsVerticalScrollIndicator = false
    }
  }
  
  private var wishListInfo: (Int, Int) = (0, 0){
    didSet {
      wishListInfoLabel.text = "\(wishListInfo.0)개의 폴더, \(wishListInfo.1)개의 장소"
    }
  }
  
  private var entireWishlist: WishlistData?
  private var wishlistFolders: [SimpleFolderData] = []
  private var dispatchGroup = DispatchGroup()
  private var mode: WishListMode = WishListMode.fromTab //true 시 확인, false시 추가
  lazy var placeId = ""
  lazy var region = ""
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
    // Modal 방식으로 화면에 나오지 않았다면 닫기 버튼을 숨긴다.
    if presentingViewController == nil {
      setCloseButtonHidden()
    }
    
    super.viewDidLoad()
    self.modalPresentationStyle = .pageSheet
    setUpWishlistCollectionView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUpWishlistCollectionView()
  }
  
  // MARK: - IBActions
  
  func setMode(mode: WishListMode) {
    self.mode = mode
  }
  func setPlaceInfo(placeId: String){
    // placeId 가져오기
    self.placeId = placeId
  }
  
  weak var delegate: SearchDataReceiveable?
  
  
  @IBAction func didTapCloseButton(_ sender: UIButton) {
    
    self.dismiss(animated: true) {
      self.delegate?.returnHeart(placeId: self.placeId)
    }
  }
  
  @IBAction func didTapAddWishlist(_ sender: UIButton) {
    guard let calendarWishListVC = WishCalendarViewController.loadFromStoryboard() as? WishCalendarViewController else {return}
    //create모드로 부름
    calendarWishListVC.setMode(mode: true)
    self.present(calendarWishListVC, animated: true) {
      calendarWishListVC.addDelegate = self
    }
  }
  
  // MARK: - Custom Instance
  
  /**
    WishlistCollectionView 의 초기설정 코드
   */
  private func setUpWishlistCollectionView() {
    guard let userId = UserManager.shared.userIdandToken?.userId, let token = UserManager.shared.userIdandToken?.token else {return}
    APIService.shared.readWishlist(userId: userId, token: token) { [weak self](result) in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        self.entireWishlist = data
        self.wishlistFolders = data.folder
        self.wishListInfo = (self.entireWishlist?.folderCount ?? 0, self.entireWishlist?.totalCount ?? 0)
        self.wishlistCollectionView.reloadData()
      case .failure(let error):
        print(self, #function, "error: \(error)")
      }
    }
  }
  
  private func setCloseButtonHidden (){
    if presentingViewController == nil {
      closeButton.isHidden = true
      return
    }
  }
  
  // TODO: 이 스타일 적용할 수 있는 클래스를 분리해볼 수 있겠다.
  // 다른 VC 에서도 재사용할 수 있게
  /**
    WishlistMainVC 를 위한 버튼/셀 디자인 적용 메서드
   */
  
  private func applyDesign<View: UIView>(to view: View) {
    view.layer.borderColor = UIColor.gray04.cgColor
    view.layer.borderWidth = 2
    view.layer.cornerRadius = 8
  }
}

extension WishlistMainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return wishlistFolders.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = collectionView.dequeueReusableCell(withReuseIdentifier: "wishlistItem", for: indexPath) as! WishlistCollectionViewCell
    
    
    // TODO: Data 전체를 넘겨줄지, Cell Layout 구성에 필요한 Data 만 넘겨줄지는 고민해야함
    
    item.fillContent(with: wishlistFolders[indexPath.row])
    
    applyDesign(to: item)
    
    return item
  }
}

extension WishlistMainViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let folderId = wishlistFolders[indexPath.row].id
    guard let token = UserManager.shared.userIdandToken?.token, let userId = UserManager.shared.userIdandToken?.userId else {return}
    switch mode {
    case .fromTab:
      guard let wishlistVC = WishlistViewController.loadFromStoryboard() as? WishlistViewController else {return}
      LoadingIndicator.show()
      APIService.shared.readFolder(token: token, userId: userId, folderId: folderId) { (result) in
        switch result {
        case .success(let data):
          wishlistVC.folderData = data
          self.navigationController?.pushViewController(wishlistVC, animated: true) {
            LoadingIndicator.hide()
          }
        case .failure(let error):
          print(error)
          LoadingIndicator.hide()
        }
      }
    case .fromCell:
      //넣기
      APIService.shared.addPlaceInFolder(token: token, userId: userId, placeId: placeId, folderId: folderId) { [weak self] (result) in
        guard let self = self else {return}
        switch result {
        case .success(let data):
          self.wishlistFolders = data.folder
          self.wishlistCollectionView.reloadData()
          self.view.makeToast("위시리스트에 저장되었습니다🐶")
          self.dismiss(animated: true, completion: nil)
        case .failure(let error):
          print("error", self, #function, error)
        }
      }
    }
  }
}

extension WishlistMainViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let figmaDefinedHeightValue: CGFloat = 86
    
    let width = wishlistCollectionView.frame.width - 1
    let height = figmaDefinedHeightValue
    
    return CGSize(width: width, height: height)
  }
}

// MARK: - Storyboard
// TODO: StoryboardInstantiable 로 대체해야 한다.
extension WishlistMainViewController: StoryboardInstantiable { }

extension WishlistMainViewController: addWishCalendarDelegate {
  func didAddWishList(name: String, startDate: Date?, endDate: Date?) {
    guard let userId = UserManager.shared.userIdandToken?.userId else {return}
    
    let folder = ["name": name, "startDate": startDate?.datePickerToString(), "endDate": endDate?.datePickerToString()]
    
    APIService.shared.createWishlistFolder(userId: userId, folder: folder as [String : Any]) { [weak self](result) in
      guard let self = self else {return}
      switch result {
      case.success(let data):
        self.wishlistFolders = data.folder
        self.wishlistCollectionView.reloadData()
      case .failure(let error):
        print("error: \(error)")
      }
    }
  }
}
