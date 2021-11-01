//
//  WishListViewController.swift
//  jjollaejjollae
//

import UIKit
import CloudKit
import Toast_Swift

class WishlistViewController: UIViewController, StoryboardInstantiable {

  //MARK: - IBOUTLET
  
  @IBOutlet weak var wishListTitle: UILabel! {
    didSet {
      wishListTitle.font = .robotoBold(size: 24)
      wishListTitle.textColor = .gray01
    }
  }
  
  @IBOutlet weak var travelInfoView: UIView! {
    didSet {
      travelInfoView.layer.shadowColor = UIColor.gray04.cgColor
      travelInfoView.layer.shadowOpacity = 0.1
      travelInfoView.layer.shadowOffset = CGSize(width: 0, height: 3)
      travelInfoView.layer.shadowRadius = 0
      travelInfoView.layer.masksToBounds = false
    }
  }

  @IBOutlet weak var locationAndDateLabel: UILabel! {
    didSet {
      locationAndDateLabel.font = .robotoMedium(size: 13)
      locationAndDateLabel.textColor = .gray01
    }
  }
  
  @IBOutlet weak var wishListCountLabel: UILabel! {
    didSet {
      wishListCountLabel.font = .robotoMedium(size: 12)
      wishListCountLabel.textColor = .gray01
    }
  }
  
  @IBOutlet weak var wishListTableView: UITableView!
  
  //MARK: - Variables & constant

  var folderData: FolderData?
  private var newDataList: [SearchResultData] = []
  private var likes: [String: Bool] = [:]
  
  let goToMapButton: UIButton = {
    let goButton = UIButton()
    goButton.backgroundColor = UIColor.themeYellow
    goButton.titleLabel?.font = UIFont.robotoBold(size: 14)
    goButton.setTitle("지도로보기", for: .normal)
    goButton.setTitleColor(.gray02, for: .normal)
    goButton.titleLabel?.textColor = .gray02
    goButton.titleLabel?.textAlignment = .center
    return goButton
  }()
  
  let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
  
  private func hideTabBar() {
    self.tabBarController?.tabBar.isHidden = true
    self.tabBarController?.tabBar.isTranslucent = true
  }
  
  private func setupFolderData() {
    locationAndDateLabel.alpha = 1
    //제목
    wishListTitle.text = folderData?.name

    //지역
    guard let regions = folderData?.regions else {return}
    var regionText = ""
    if regions.count > 1 {
      regionText = "\(regions[0]) 외 \(regions.count - 1)"
    } else if regions.count == 1 {
      regionText = "\(regions[0])"
    }

    //날짜
    if let startDate = folderData?.startDate, let endDate = folderData?.endDate {
      if startDate == "" || endDate == "" {
        locationAndDateLabel.text = ""
      } else {
        let startDate = startDate.components(separatedBy: "T")[0].components(separatedBy: "-")[1...2].joined(separator: ".")
        let endDate = endDate.components(separatedBy: "T")[0].components(separatedBy: "-")[1...2].joined(separator: ".")
        if regionText != "" {
          locationAndDateLabel.text = regionText+"•"+"\(startDate)~\(endDate)"
        } else {
          locationAndDateLabel.text = "\(startDate)~\(endDate)"
        }
      }
    } else {
      if regionText == "" {
        locationAndDateLabel.alpha = 0
      } else {
        locationAndDateLabel.text = regionText
      }
    }

    //장소 갯수
    guard let placeNum = folderData?.count else {return}
    wishListCountLabel.text = "\(placeNum)개의 장소"

    // 장소에 갯수에 따라 goToMapButton 보여지기 or Not
    if placeNum == 0 {
      goToMapButton.isHidden = true
    } else {
      goToMapButton.isHidden = false
    }
    
    guard let dataList = folderData?.contents else {return}
    newDataList = dataList
    
    for data in newDataList {
      likes.updateValue(data.isWish ?? false, forKey: data.id)
    }
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    goToMapButtonUISetting()
    setupFolderData()
    wishListTableView.delegate = self
    wishListTableView.dataSource = self
    wishListTableView.register(nib, forCellReuseIdentifier: "resultCell")
    if #available(iOS 15.0, *) {
//      wishListTableView.sectionHeaderTopPadding = 0
    }
    wishListTableView.separatorStyle = .none
    wishListTableView.tableFooterView = UIView(frame: CGRect.zero)
    wishListTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: wishListTableView.frame.size.width, height: 10))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupFolderData()
  }
  
  deinit {
    print("wishListvc deinit")
  }
  
  //MARK: - Functions
  override func viewDidLayoutSubviews() {
    goToMapButton.setRounded(radius: nil)
    goToMapButton.addShadow()
  }
  
  @objc private func tapGoToMapButton(_ sender: Any?) {
    let wishMapStoryboard = UIStoryboard(name: "WishMap", bundle: nil)
    guard let wishMapVC = wishMapStoryboard.instantiateViewController(
            identifier: "WishMapViewController") as? WishMapViewController else {
      return
    }
    //test를 위한 주석
    wishMapVC.setDataList(with: self.newDataList)
    wishMapVC.setTravelInfoData(with: (title: wishListTitle.text ?? "", locationAndDate: locationAndDateLabel.text))
    wishMapVC.modalPresentationStyle = .fullScreen
    present(wishMapVC, animated: true) {
      // 아니면 모델에서 구성하기 ??
    }
  }
  
  private func goToMapButtonUISetting() {
    view.addSubview(goToMapButton)
    goToMapButton.translatesAutoresizingMaskIntoConstraints = false
    goToMapButton.roundedButton(cornerRadius: nil)
    goToMapButton.bottomAnchor.constraint(
      equalTo: self.view.bottomAnchor, constant: -73).isActive = true
    goToMapButton.widthAnchor.constraint(
      equalToConstant: self.view.frame.width * 121 / 375).isActive = true
    goToMapButton.heightAnchor.constraint(equalTo: goToMapButton.widthAnchor,
                                         multiplier: 52 / 121).isActive = true
    goToMapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    goToMapButton.addTarget(self, action: #selector(tapGoToMapButton), for: .touchUpInside)
  }
  
  
  //MARK: - IBACTION

  @IBAction private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction private func didTapOptionButton(_ sender: UIButton) {
    //TODO:option 화면 구현
    let wishCalendarStoryBoard = UIStoryboard(name: "WishCalendar", bundle: nil)
    guard let wishCalendarVC = wishCalendarStoryBoard.instantiateViewController(identifier: "WishCalendarViewController") as? WishCalendarViewController else {return}

    let optionActionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let editOption = UIAlertAction(title: "수정", style: .default, handler: { [weak self] _ in
      guard let self = self else {return}
      // 둘다 있거나 둘다 없거나
      var wishModel: Wish?
      if let startDate = self.folderData?.startDate?.components(separatedBy: "T")[0].stringToDate(), let endDate = self.folderData?.endDate?.components(separatedBy: "T")[0].stringToDate() {
        wishModel = Wish(wishTitle: self.folderData?.name, Dates: [startDate, endDate])
      } else {
        wishModel = Wish(wishTitle: self.folderData?.name, Dates: nil)
      }
      _ = wishCalendarVC.wishCompletionHandler?(wishModel)
      wishCalendarVC.delegate = self
      self.present(wishCalendarVC, animated: true)
    })
    let deleteOption = UIAlertAction(title: "삭제", style: .destructive) { [weak self]_ in
      guard let self = self else {return}
      guard let token = UserManager.shared.userIdandToken?.token else {return}
      guard let userId = UserManager.shared.userIdandToken?.userId else {return}
      guard let folderId = self.folderData?.id else {return}
      guard let folderCount = self.folderData?.count else {return}
      if folderCount < 2 {
        self.view.makeToast("1개는 남겨두개🐶", duration: 1)
        return}
      APIService.shared.deleteFolder(token: token, userId: userId, folderId: folderId) { [weak self](result) in
        guard let self = self else {return}
        switch result {
        case .success(let data):
          print("삭제성공")
          self.setupFolderData()
          self.wishListTableView.reloadData()
          //TODO: DELEGATE로 변화 업데이트
          self.navigationController?.popViewController(animated: true)
        case .failure(let error):
          print("error \(error)")
        }
      }
    }
    optionActionSheetController.addAction(editOption)
    optionActionSheetController.addAction(deleteOption)
    optionActionSheetController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    let subview = optionActionSheetController.view.subviews.first! as UIView
    let alertContentView = subview.subviews.first! as UIView
    alertContentView.setRounded(radius: 10)
    alertContentView.overrideUserInterfaceStyle = .light
    alertContentView.backgroundColor = UIColor.white
    optionActionSheetController.view.setRounded(radius: 10)
    optionActionSheetController.view.tintColor = .themeGreen
    self.present(optionActionSheetController, animated: true, completion: nil)
  }
}



extension WishlistViewController: UITableViewDelegate {
  /**
   - Author: 박우찬
   */
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    LoadingIndicator.show()
    
    let placeId = newDataList[indexPath.row].id
    
    APIService.shared.fetchPlaceInfo(placeId: placeId) { result in
      
      switch result {
        case .success(let data):

          guard let vc = PlaceDetailTableViewController.loadFromStoryboard() as? PlaceDetailTableViewController else { return }

          let placeInfo = PlaceInfo.init(placeID: placeId, data: data)
          
          vc.placeInfo = placeInfo
          
          self.navigationController?.pushViewController(vc, animated: true, completion: {
            LoadingIndicator.hide()
          })
          
        case .failure(let statusCode):
          print(statusCode)
      }
    }
  }
  
  
}

extension WishlistViewController: UITableViewDataSource, SearchResultCellDelegate {
  
  func didTapHeart(for placeId: String, like: Bool) {
    if like == true {
      likes[placeId] = false
      guard let userId = UserManager.shared.userIdandToken?.userId else {return}
      guard let token = UserManager.shared.userIdandToken?.token else {return}
      guard let folderId = folderData?.id else {return}
      APIService.shared.deletePlaceInFolder(token: token, userId: userId, folderId: folderId, placeId: placeId) { (result) in
        switch result {
        case .success(let data):
          print("제거 성공")
          APIService.shared.readFolder(token: token, userId: userId, folderId: folderId) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
              self.folderData = data
              self.setupFolderData()
              self.wishListTableView.reloadData()
            case .failure(let error):
              print(error)
            }
          }
        case .failure(let error):
          print("error \(error)")
        }
      }
    } else {
      likes[placeId] = true
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newDataList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell else {
      return UITableViewCell()
    }
    
    cell.delegate = self
    cell.placeId = newDataList[indexPath.row].id
  
    
    let item = newDataList[indexPath.row]
    
    cell.cellImageView.setImage(with: item.imagesUrl.first ?? "default")
    cell.addressLabel.text = item.address.joined(separator: " ")
    cell.locationNameLabel.text = item.title
    cell.locationTypeLabel.text = nil
    cell.numberOfReviewsLabel.text = "(\(item.reviewCount))"
    cell.starPointLabel.text = String(format: "%.1f", item.reviewPoint ?? 0)
    
    cell.isWish = likes[cell.placeId] == true
    
    newDataList[indexPath.row].isWish = likes[cell.placeId] == true //이것의 이유?
    
    return cell
  }
}

extension WishlistViewController: EditWishCalendarDelegate {
  
  func didChangeSchedule(name: String, startDate: Date?, endDate: Date?) {
    guard let token = UserManager.shared.userIdandToken?.token, let userId = UserManager.shared.userIdandToken?.userId else {return}
    guard let folderId = folderData?.id else {return}
    folderData?.startDate = startDate?.datePickerToString() ?? ""
    folderData?.endDate = endDate?.datePickerToString() ?? ""
    folderData?.name = name
    
    setupFolderData()
    
    APIService.shared.patchFolder(token: token, userId: userId, folderId: folderId, name: name, startDate: startDate?.datePickerToString() ?? "", endDate: endDate?.datePickerToString() ?? "") { (result) in
      switch result {
      case .success(let data):
        print(data)
      case .failure(let error):
        print("failure \(error)")
        
      }
    }
  }
  
}
