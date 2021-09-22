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
  var locationList: [SearchResultInfo]?
}

class WishListViewController: UIViewController, StoryboardInstantiable {
  
  static func loadFromStoryboard(fileName name: String) -> UIViewController {
    let identifier = "\(name)ViewController"
    let storyboard  = UIStoryboard(name: name, bundle: nil)
    let wishListVC = storyboard.instantiateViewController(identifier: identifier)
    return wishListVC
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

  let modelController = ModelController()
  
  private var dataList: [SearchResultInfo] = []
  private var likes: [Int: Bool] = [:]
  
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
      self.dataList = travelInfo?.locationList ?? []
      wishListCountLabel.text = "\(self.dataList.count)개의 장소"
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
    hideTabBar()
    goToMapButtonUISetting()
    wishListTableView.delegate = self
    wishListTableView.dataSource = self
    wishListTableView.register(nib, forCellReuseIdentifier: "resultCell")
    wishListTableView.separatorStyle = .none
    wishListTableView.tableFooterView = UIView(frame: CGRect.zero)
    wishListTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: wishListTableView.frame.size.width, height: 10))
    self.dataList = modelController.accommoList
    self.travelInfo = TravelInfo(
      title: "2021 쪼꼬랑 여름휴가",
      location: "제주시",
      startDate: Date(),
      endDate: Date(),
      locationList: self.dataList
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
    wishMapVC.setDataList(with: self.dataList)
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
      present(wishCalendarVC, animated: true)
    })
    let deleteOption = UIAlertAction(title: "삭제", style: .destructive) {_ in 
      print("삭제하기")
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

extension WishListViewController: UITableViewDelegate {
  //TODO: 그 장소 Detail화면으로 넘어가기
}

extension WishListViewController: UITableViewDataSource, SearchResultCellDelegate {
  
  func didTapHeart(for placeId: Int, like: Bool) {
    likes[placeId] = like == true ? true : false
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return dataList.count
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell else {
      return UITableViewCell()
    }
    
    cell.delegate = self
    cell.placeId = dataList[indexPath.row].id
    
    let item = dataList[indexPath.row]
    if let day = item.days, let address = item.location, let price = item.prices {
      cell.DaysLabel.isHidden = false
      cell.addressLabel.isHidden = false
      cell.priceLabel.isHidden = false
      cell.DaysLabel.text = "\(day)박 요금"
      cell.addressLabel.text = address
      cell.priceLabel.text = "\(price)원"
    } else {
      cell.addressLabel.text = nil
      cell.DaysLabel.text = nil
      cell.priceLabel.text = nil
      cell.contentStackView.removeArrangedSubview(cell.addressLabel)
    }
    
    cell.locationNameLabel.text = item.name
    cell.locationTypeLabel.text = item.type ?? ""
    cell.numberOfReviewsLabel.text = "(\(item.numbers ?? 0))"
    cell.starPointLabel.text = " \(item.points ?? 0)"
    
    cell.isWish = likes[cell.placeId] == true
    dataList[indexPath.row].like = likes[cell.placeId] == true
    
    return cell
  }
}
