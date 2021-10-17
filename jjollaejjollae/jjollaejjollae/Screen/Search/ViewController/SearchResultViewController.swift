//
//  SearchResultViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

class SearchResultViewController: UIViewController, StoryboardInstantiable {
  //MARK: - IBOUTLET
  
  @IBOutlet weak var headView: UIView! {
    didSet {
      headView.backgroundColor = .themePaleGreen
    }
  }
  @IBOutlet weak var backButton: UIButton! {
    didSet {
      backButton.setTitleColor(.gray01, for: .normal)
    }
  }
  
  @IBOutlet weak var searchTextField: UITextField! {
    didSet {
      searchTextField.setRounded(radius: nil)
      //get
      searchTextField.text = SearchManager.shared.searchText
      searchTextField.returnKeyType = .search
      searchTextField.delegate = self
    }
  }
  @IBOutlet weak var restaurantButton: RoundButton!
  @IBOutlet weak var landMarkButton: RoundButton!
  @IBOutlet weak var cafeButton: RoundButton!
  @IBOutlet weak var accommodationButton: RoundButton!
 
  @IBOutlet weak var setFilterButton: UIButton! {
    didSet {
      setFilterButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
      setFilterButton.tintColor = .색44444
    }
  }
  @IBOutlet weak var numberOfResultLabel: UILabel! {
    didSet {
      numberOfResultLabel.text = "0개 이상의 숙소"
      numberOfResultLabel.font = .robotoRegular(size: 12)
      numberOfResultLabel.textColor = .색44444
    }
  }
  @IBOutlet var setOrderButton: UIButton! {
    didSet {
      setOrderButton.layer.borderWidth = 0
      setOrderButton.setTitle("추천순 ▼", for: .normal)
      setOrderButton.tintColor = .색44444
      setOrderButton.titleLabel?.font = .robotoMedium(size: 13)
    }
  }
  @IBOutlet var resultTableView: UITableView!
  
  @IBOutlet weak var separateLine: UIView! {
    didSet {
      separateLine.backgroundColor = .gray05
    }
  }
  @IBOutlet weak var filterStackView: UIStackView!
  @IBOutlet weak var NumberLabelfilterStackView: UIStackView!
  @IBOutlet weak var tableViewTop: NSLayoutConstraint!
  
  //MARK: - variable & constant
  
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
  private var searchResultDataSources: [UITableViewDataSource] = []
  private var dataList = [SearchResultInfo]()
  lazy var likes: [Int : Int] = [:]
  
  let accommodationDataSource = AccommodationDataSource()
  let restaurantDataSource = RestaurantDataSource()
  let cafeDataSource = CafeDataSource()
  let landmarkDataSource = LandmarkDataSource()
  
  let modelController = ModelController()
  let searchManager = SearchManager.shared
  private var defaultHeight: CGFloat  = 13
  private var buttons : [UIButton] = []
  private let transparentView = UIView()
  private var selectedButton = UIButton()
  private let headerHeight: CGFloat = 80
//  private var totalHeight: CGFloat = 0
  
  private var mode = true  // true: 지역검색후 넘어오는 화면, false: 카페라고만 치는 경우
  
  private func setMode() {
    let text = SearchManager.shared.searchText
    switch text {
    case "카페", "맛집", "레스토랑", "숙소", "명소", "관광지":
      self.mode = false
    default:
      self.mode = true
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLocationFilterButtonUI()
    setMode()
    updatedModeUI()
    
    setupReviewTableView()
//    defaultHeight = HeightTobeDynamioc.constant
    
    //MARK: - gotoMapButton setting
    
    view.addSubview(goToMapButton)
    goToMapButton.translatesAutoresizingMaskIntoConstraints = false
    goToMapButton.roundedButton(cornerRadius: nil)
    goToMapButton.bottomAnchor.constraint(
      equalTo: self.view.bottomAnchor, constant: -78).isActive = true
    goToMapButton.widthAnchor.constraint(
      equalToConstant: self.view.frame.width * 121 / 375).isActive = true
    goToMapButton.heightAnchor.constraint(equalTo: goToMapButton.widthAnchor,
                                         multiplier: 52 / 121).isActive = true
    goToMapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    goToMapButton.addTarget(self, action: #selector(tapGoToMapButton), for: .touchUpInside)
    updatedModeUI()
  }
  
  //MARK: - resultTableView setup
  private func setupReviewTableView() {
    resultTableView.delegate = self
    resultTableView.register(nib, forCellReuseIdentifier: "resultCell")
    resultTableView.isUserInteractionEnabled = true
    accommodationDataSource.dataList = modelController.accommoList
    restaurantDataSource.dataList = modelController.restaurantList
    cafeDataSource.dataList = modelController.cafeList
    accommodationDataSource.setCallerVC(viewController: self)
    restaurantDataSource.setCallerVC(viewController: self)
    landmarkDataSource.setCallerVC(viewController: self)
    cafeDataSource.setCallerVC(viewController: self)
    landmarkDataSource.dataList = modelController.landmarkList
    searchResultDataSources = [accommodationDataSource,
                               restaurantDataSource,
                               cafeDataSource,
                               landmarkDataSource]
    resultTableView.dataSource = searchResultDataSources[0]
    self.dataList = accommodationDataSource.dataList
    resultTableView.tableFooterView = UIView(frame: CGRect.zero)
    resultTableView.separatorStyle = .none
  }

  private func updatedModeUI() {
    if mode {
      NumberLabelfilterStackView.isHidden = false
      filterStackView.isHidden = false
      separateLine.isHidden = false
      setOrderButton.isHidden = false
      tableViewTop.constant = defaultHeight
    } else {
      NumberLabelfilterStackView.isHidden = true
      filterStackView.isHidden = true
      separateLine.isHidden = true
      setOrderButton.isHidden = true
      tableViewTop.constant = 0 - (headerHeight + 10)
    }
  }
  
  override func viewDidLayoutSubviews() {
    goToMapButton.setRounded(radius: nil)
    goToMapButton.addShadow()
  }
  
  @objc private func tapGoToMapButton() {
    // TODO Map으로 넘어가기
    let searchMapStoryboard = UIStoryboard(name: "SearchMap", bundle: nil)
    guard let searchMapVC = searchMapStoryboard.instantiateViewController(
            identifier: "SearchMapViewController") as? SearchMapViewController else {
      return
    }
    searchMapVC.setDataList(with: self.dataList)
    present(searchMapVC, animated: true)
  }
  
  private func setLocationFilterButtonUI() {
    buttons = [restaurantButton, landMarkButton, cafeButton, accommodationButton]
    buttons.forEach { (button) in
      button.layer.borderColor = UIColor.themePaleGreen.cgColor
      button.layer.borderWidth = 1.0
      button.backgroundColor = .white
      button.tintColor = .gray01
      button.titleLabel?.font = .robotoMedium(size: 13)
    }
    buttons.last?.backgroundColor = UIColor.themePaleGreen
  }
  
  private func updateButtonUI(_ sender: UIButton) {
    buttons.forEach { button in
      if button == sender {
        button.backgroundColor = .themePaleGreen
      } else {
        button.backgroundColor = .white
      }
    }
  }
  
  @IBAction private func didTapFilterButtons(_ sender: UIButton) {
    switch sender {
    case restaurantButton:
      resultTableView.dataSource = searchResultDataSources[1]
      dataList = restaurantDataSource.dataList
//      HeightTobeDynamioc.constant = 0 - setFilterButton.frame.height
//      scheduleStackView.isHidden = true
    case landMarkButton:
      resultTableView.dataSource = searchResultDataSources[3]
      dataList = landmarkDataSource.dataList
//      HeightTobeDynamioc.constant = 0 - setFilterButton.frame.height
//      scheduleStackView.isHidden = true
    case cafeButton:
      resultTableView.dataSource = searchResultDataSources[2]
      dataList = cafeDataSource.dataList
//      HeightTobeDynamioc.constant = 0 - setFilterButton.frame.height
//      scheduleStackView.isHidden = true
    case accommodationButton:
      resultTableView.dataSource = searchResultDataSources[0]
      dataList = accommodationDataSource.dataList
//      scheduleStackView.isHidden = false
//      HeightTobeDynamioc.constant = defaultHeight
    default:
      return
    }
    updateButtonUI(sender)
    resultTableView.reloadData()
  }
  
  @IBAction private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  

}

extension SearchResultViewController {

  @IBAction func didTapSetOrderButton(_ sender: UIButton) {
    showAlertController(style: .actionSheet)
  }
  //"리뷰 많은순", "최근 등록순", "별점 높은순"
  private func showAlertController(style: UIAlertController.Style) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    let recommendAction = UIAlertAction(title: "추천순", style: .default) { [weak self]
      result in self?.setOrderButton.setTitle("추천순▼", for: .normal)
      //여기서 백그라운드큐에서 sort하고 main큐에서 async로 보여줘야할듯
      // 큐는 concurrent로 일단 백그라운드로 ㄲ
    }
    let reviewAction = UIAlertAction(title: "리뷰 많은순", style: .default) {
      [weak self] result in self?.setOrderButton.setTitle("리뷰 많은순▼", for: .normal)
    }
    let recentAction = UIAlertAction(title: "최근 등록순", style: .default) { [weak self] result in
      self?.setOrderButton.setTitle("최근 등록순▼", for: .normal)
    }
    let starAction = UIAlertAction(title: "별점 높은순", style: .default) { [weak self] result in
      self?.setOrderButton.setTitle("별점 높은순▼", for: .normal)
    }
    let subview = alertController.view.subviews.first! as UIView
    let alertContentView = subview.subviews.first! as UIView
    alertContentView.setRounded(radius: 10)
    alertContentView.overrideUserInterfaceStyle = .light
    alertContentView.backgroundColor = UIColor.white
    alertController.view.setRounded(radius: 10)
    alertController.view.tintColor = .themeGreen
    alertController.addAction(recommendAction)
    alertController.addAction(reviewAction)
    alertController.addAction(recentAction)
    alertController.addAction(starAction)
    alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    self.present(alertController, animated: true, completion: nil);
  }

  
  @IBAction func didTapFilterButton(_ sender: UIButton) {
    guard let filterVC = FilterViewController.loadFromStoryboard() as? FilterViewController else {return}
    self.navigationController?.present(filterVC, animated: true, completion: nil)
    // completion에서 data 보내줘야함
    // 그렇다면??? userdefaults로 해야할듯?
  }
}

//MARK: - tableviewDelegate

extension SearchResultViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //서버와 연결
    }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if !mode {
      return headerHeight
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if !mode {
      let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
      let headerLabel = UILabel()
      headerLabel.translatesAutoresizingMaskIntoConstraints = false
      headerLabel.text = "내 근처 \(self.searchTextField.text == "" ? "갈만한 곳" : self.searchTextField.text ?? "갈만한 곳")"
      headerLabel.font = .robotoBold(size: 18)
      headerLabel.textColor = .gray02
      header.backgroundColor = .white
      header.addSubview(headerLabel)
      
      headerLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16).isActive = true
      headerLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 46).isActive = true
      
      return header
    }
    return nil
  }
  
}

//MARK: - KEYBOARD
extension SearchResultViewController: UITextFieldDelegate, Searchable {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    gotoSearchVC(from: self)
  }
}




//MARK: - NOT USE & later USE

//  private var oldDates: [Date?] = [Date()
//                                   , Calendar.current.date(byAdding: .day, value: 1, to: Date())]
//  private var dates: [Date?] = [Date(),
//                                Calendar.current.date(byAdding: .day, value: 1, to: Date())] {
//    didSet {
//      if !dates.contains(nil) {
//        let firstDay = (dates.first!)!
//        let lastDay = (dates.last!)!
//        setScheduleButton.setTitle(
//          "\(firstDay.dateForSeachResult()) - \(lastDay.dateForSeachResult())", for: .normal)
//        oldDates = dates
//      } else {
//        let oldFirstDay = (oldDates.first!)!
//        let oldLastDay = (oldDates.last!)!
//        setScheduleButton.setTitle(
//          "\(oldFirstDay.dateForSeachResult()) - \(oldLastDay.dateForSeachResult())", for: .normal)
//      }
//    }
//  }


//  @IBAction private func didTapSetScheduleButton(_ sender: UIButton) {
//    let calendarStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
//    guard let calendarVC = calendarStoryboard.instantiateViewController(
//            identifier: "CalendarViewController") as? CalendarViewController else {return}
//    if !dates.contains(nil) {
//      calendarVC.setDefaultDateLabel(defaultDate: dates)
//    } else {
//      calendarVC.setDefaultDateLabel(defaultDate: oldDates)
//    }
//    calendarVC.dateCompletionHandler = {
//      [weak self] days in
//      self?.dates = days
//      return days
//    }
//    present(calendarVC, animated: true)
//  }
