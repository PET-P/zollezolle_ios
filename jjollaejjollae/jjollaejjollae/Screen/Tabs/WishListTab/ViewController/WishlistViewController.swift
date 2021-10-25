//
//  WishListViewController.swift
//  jjollaejjollae
//

import UIKit

struct TravelInfo {
  var title: String
  var location: String?
  var startDate: Date?
  var endDate: Date?
  var locationList: [SearchResultData]?
}

class WishlistViewController: UIViewController, StoryboardInstantiable, EditWishCalendarDelegate {
  
  func didChangeSchedule(startDate: Date?, endDate: Date?) {
    travelInfo?.startDate = startDate
    travelInfo?.endDate = endDate
  }
  
  func didChangeWishListTitle(title: String) {
    travelInfo?.title = title
  }
  
  
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

  
  private var newDataList: [SearchResultData] = []
  private var likes: [String: Bool] = [:]
  
  private var travelInfo: TravelInfo? {
    didSet {
      wishListTitle.text = travelInfo?.title
      if let location = travelInfo?.location {
        if let startDate = travelInfo?.startDate, let endDate = travelInfo?.endDate {
          locationAndDateLabel.text = "\(location) \(startDate.dateForCalendar()) ~ \(endDate.dateForCalendar())"
        } else {
          locationAndDateLabel.text = "\(location)"
        }
      } else {
        if let startDate = travelInfo?.startDate, let endDate = travelInfo?.endDate {
          locationAndDateLabel.text = "\(startDate.dateForCalendar()) ~ \(endDate.dateForCalendar())"
        } else {
          locationAndDateLabel.text = nil
        }
      }
      self.newDataList = travelInfo?.locationList ?? []
      wishListCountLabel.text = "\(self.newDataList.count)개의 장소"
      if self.newDataList.count == 0 {
        goToMapButton.isHidden = true
      } else {
        goToMapButton.isHidden = false
      }
    }
  }

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
  
  func hideTabBar() {
    self.tabBarController?.tabBar.isHidden = true
    self.tabBarController?.tabBar.isTranslucent = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    goToMapButtonUISetting()
    wishListTableView.delegate = self
    wishListTableView.dataSource = self
    wishListTableView.register(nib, forCellReuseIdentifier: "resultCell")
    wishListTableView.separatorStyle = .none
    wishListTableView.tableFooterView = UIView(frame: CGRect.zero)
    wishListTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: wishListTableView.frame.size.width, height: 10))
    self.travelInfo = TravelInfo(
      title: "2021 쪼꼬랑 여름휴가",
      location: "제주시",
      startDate: Date(),
      endDate: Date(),
      locationList: self.newDataList
    )
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
//    wishMapVC.setDataList(with: self.newDataList)
    wishMapVC.setTravelInfoData(with: (title: wishListTitle.text ?? "", locationAndDate: locationAndDateLabel.text))
    wishMapVC.modalPresentationStyle = .fullScreen
    present(wishMapVC, animated: true) {
      // 여기서 이번에 들어오는 Data들은 wishList에 있는 것인지 알려주기?
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
  
//  var wishCompletionHandler: ((Wish?) -> (Wish?))?
  
  @IBAction private func didTapOptionButton(_ sender: UIButton) {
    //TODO:option 화면 구현
    let wishCalendarStoryBoard = UIStoryboard(name: "WishCalendar", bundle: nil)
    guard let wishCalendarVC = wishCalendarStoryBoard.instantiateViewController(identifier: "WishCalendarViewController") as? WishCalendarViewController else {return}
    
    
    let optionActionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let editOption = UIAlertAction(title: "수정", style: .default, handler: { [self] _ in
      // 둘다 있거나 둘다 없거나
      var wishModel: Wish?
      if let startDate = self.travelInfo?.startDate, let endDate = self.travelInfo?.endDate {
        wishModel = Wish(wishTitle: self.travelInfo?.title, Dates: [startDate, endDate])
      } else {
        wishModel = Wish(wishTitle: self.travelInfo?.title, Dates: nil)
      }
      _ = wishCalendarVC.wishCompletionHandler?(wishModel)
//      wishCalendarVC.setData(data: Wish())
      wishCalendarVC.delegate = self
      present(wishCalendarVC, animated: true)
    })
    let deleteOption = UIAlertAction(title: "삭제", style: .destructive) {_ in
      guard let token = UserManager.shared.userIdandToken?.token else {return}
      guard let userId = UserManager.shared.userIdandToken?.userId else {return}
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
  //TODO: 그 장소 Detail화면으로 넘어가기
}

extension WishlistViewController: UITableViewDataSource, SearchResultCellDelegate {
  
  func didTapHeart(for placeId: String, like: Bool) {
    if like == true {
      likes[placeId] = false
    } else {
      likes[placeId] = true
      guard let wishListMainVC = WishlistMainViewController.loadFromStoryboard() as? WishlistMainViewController else {
        return
      }
      self.present(wishListMainVC, animated: true, completion: nil) //
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
    
    cell.locationNameLabel.text = item.title
    cell.locationTypeLabel.text = nil
    cell.numberOfReviewsLabel.text = "(\(item.reviewCount))"
    cell.starPointLabel.text = " \(item.reviewPoint ?? 0)"
    
    cell.isWish = likes[cell.placeId] == true
    newDataList[indexPath.row].isWish = likes[cell.placeId] == true //이것의 이유?
    
    return cell
  }
}
