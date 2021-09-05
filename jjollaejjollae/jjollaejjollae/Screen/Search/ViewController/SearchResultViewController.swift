//
//  SearchResultViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

class SearchResultViewController: UIViewController {
  //MARK: - IBOUTLET
  @IBOutlet weak var headView: UIView! {
    didSet {
      headView.backgroundColor = .쫄래페일그린
    }
  }
  @IBOutlet weak var backButton: UIButton! {
    didSet {
      backButton.tintColor = .쫄래블랙
    }
  }
  
  @IBOutlet weak var searchTextField: UITextField! {
    didSet {
      searchTextField.setRounded(radius: nil)
    }
  }
  @IBOutlet weak var restaurantButton: RoundButton!
  @IBOutlet weak var landMarkButton: RoundButton!
  @IBOutlet weak var cafeButton: RoundButton!
  @IBOutlet weak var accommodationButton: RoundButton!
  @IBOutlet weak var setScheduleButton: UIButton! {
    didSet {
      setScheduleButton.setRounded(radius: 4)
      setScheduleButton.backgroundColor = UIColor(rgb: 0xF4F4F4)
      setScheduleButton.setTitle("\(Date().dateForSeachResult()) - \(Calendar.current.date(byAdding: .day, value: 1, to: Date())?.dateForSeachResult() ?? "\(Date().dateForSeachResult())")", for: .normal)
      setScheduleButton.tintColor = .색44444
      setScheduleButton.titleLabel?.font = .robotoRegular(size: 12)
      setScheduleButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
  }
  @IBOutlet weak var setPersonnelButton: UIButton! {
    didSet {
      setPersonnelButton.setRounded(radius: 4)
      setPersonnelButton.backgroundColor = UIColor(rgb: 0xF4F4F4)
      setPersonnelButton.setTitle("성인 2/강아지 1", for: .normal)
      setPersonnelButton.tintColor = .색44444
      setPersonnelButton.titleLabel?.font = .robotoRegular(size: 12)
      setPersonnelButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    }
  }
  @IBOutlet weak var setFilterButton: UIButton! {
    didSet {
      setFilterButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
      setFilterButton.tintColor = .색44444
    }
  }
  @IBOutlet weak var scheduleStackView: UIStackView!
  @IBOutlet weak var HeightTobeDynamioc: NSLayoutConstraint!
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
      separateLine.backgroundColor = .색e8
    }
  }
  
  //MARK: - variable & constant
  
  let goToMapButton: UIButton = {
    let goButton = UIButton()
    goButton.backgroundColor = UIColor.쫄래앨로우
    goButton.titleLabel?.font = UIFont.robotoBold(size: 14)
    goButton.setTitle("지도로보기", for: .normal)
    goButton.setTitleColor(.색44444, for: .normal)
    goButton.titleLabel?.textColor = .색44444
    goButton.titleLabel?.textAlignment = .center
    return goButton
  }()
  
  let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
  private var searchResultDataSources: [UITableViewDataSource] = []
  private var dataList = [SearchResultInfo]()
  lazy var likes: [Int : Int] = [:]
  private var oldDates: [Date?] = [Date(), Calendar.current.date(byAdding: .day, value: 1, to: Date())]
  private var dates: [Date?] = [Date(), Calendar.current.date(byAdding: .day, value: 1, to: Date())] {
    didSet {
      if !dates.contains(nil) {
        let firstDay = (dates.first!)!
        let lastDay = (dates.last!)!
        setScheduleButton.setTitle("\(firstDay.dateForSeachResult()) - \(lastDay.dateForSeachResult())", for: .normal)
        oldDates = dates
      } else {
        let oldFirstDay = (oldDates.first!)!
        let oldLastDay = (oldDates.last!)!
        setScheduleButton.setTitle("\(oldFirstDay.dateForSeachResult()) - \(oldLastDay.dateForSeachResult())", for: .normal)
      }
    }
  }
  
  let accommodationDataSource = AccommodationDataSource()
  let restaurantDataSource = RestaurantDataSource()
  let cafeDataSource = CafeDataSource()
  let landmarkDataSource = LandmarkDataSource()
  let dropdownDataSource = DropDownDataSource()
  
  let modelController = ModelController()
  private var defaultHeight: CGFloat  = 0
  private var buttons : [UIButton] = []
  private let transparentView = UIView()
  let dropDownTableView = UITableView()
  private var selectedButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //MARK: - resultTableView setup
    resultTableView.delegate = self
    resultTableView.register(nib, forCellReuseIdentifier: "resultCell")
    resultTableView.isUserInteractionEnabled = true
    accommodationDataSource.dataList = modelController.accommoList
    restaurantDataSource.dataList = modelController.restaurantList
    cafeDataSource.dataList = modelController.cafeList
    landmarkDataSource.dataList = modelController.landmarkList
    searchResultDataSources = [accommodationDataSource,
                               restaurantDataSource,
                               cafeDataSource,
                               landmarkDataSource]
    resultTableView.dataSource = searchResultDataSources[0]
    self.dataList = accommodationDataSource.dataList
    resultTableView.tableFooterView = UIView(frame: CGRect.zero)
    resultTableView.separatorStyle = .none
    
    //MARK: - dropdown setup
    
    dropDownTableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    dropDownTableView.dataSource = dropdownDataSource
    dropDownTableView.separatorStyle = .none
    dropDownTableView.delegate = self
    dropDownTableView.rowHeight = 50
    setLocationFilterButtonUI()
    defaultHeight = HeightTobeDynamioc.constant
    
    //MARK: - gotoMapButton setting
    view.addSubview(goToMapButton)
    goToMapButton.translatesAutoresizingMaskIntoConstraints = false
    goToMapButton.roundedButton(cornerRadius: nil)
    goToMapButton.bottomAnchor.constraint(
      equalTo: view.bottomAnchor, constant: -78).isActive = true
    goToMapButton.widthAnchor.constraint(equalToConstant: 121).isActive = true
    goToMapButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    goToMapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    goToMapButton.addTarget(self, action: #selector(tapGoToMapButton), for: .touchUpInside)
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
      button.layer.borderColor = UIColor.쫄래페일그린.cgColor
      button.layer.borderWidth = 1.0
      button.backgroundColor = .white
      button.tintColor = .쫄래블랙
      button.titleLabel?.font = .robotoMedium(size: 13)
    }
    buttons.last?.backgroundColor = UIColor.쫄래페일그린
  }
  
  private func updateButtonUI(_ sender: UIButton) {
    buttons.forEach { button in
      if button == sender {
        button.backgroundColor = .쫄래페일그린
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
      HeightTobeDynamioc.constant = 0 - setFilterButton.frame.height
      scheduleStackView.isHidden = true
    case landMarkButton:
      resultTableView.dataSource = searchResultDataSources[3]
      dataList = landmarkDataSource.dataList
      HeightTobeDynamioc.constant = 0 - setFilterButton.frame.height
      scheduleStackView.isHidden = true
    case cafeButton:
      resultTableView.dataSource = searchResultDataSources[2]
      dataList = cafeDataSource.dataList
      HeightTobeDynamioc.constant = 0 - setFilterButton.frame.height
      scheduleStackView.isHidden = true
    case accommodationButton:
      resultTableView.dataSource = searchResultDataSources[0]
      dataList = accommodationDataSource.dataList
      scheduleStackView.isHidden = false
      HeightTobeDynamioc.constant = defaultHeight
    default:
      return
    }
    updateButtonUI(sender)
    resultTableView.reloadData()
  }
  
  @IBAction private func didTapSetScheduleButton(_ sender: UIButton) {
    let calendarStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
    guard let calendarVC = calendarStoryboard.instantiateViewController(
            identifier: "CalendarViewController") as? CalendarViewController else {return}
    if !dates.contains(nil) {
      calendarVC.setDefaultDateLabel(defaultDate: dates)
    } else {
      calendarVC.setDefaultDateLabel(defaultDate: oldDates)
    }
    calendarVC.dateCompletionHandler = {
      [weak self] days in
      self?.dates = days
      return days
    }
    present(calendarVC, animated: true)
  }
}
//MARK: - DropDownMenu

extension SearchResultViewController {
  func addTransparentView(frames: CGRect) {
    let window = UIApplication.shared.windows.first {$0.isKeyWindow}
    transparentView.frame = window?.frame ?? self.view.frame
    view.addSubview(transparentView)
    
    dropDownTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height,
                                     width: frames.width, height: 0)
    view.addSubview(dropDownTableView)
    dropDownTableView.layer.cornerRadius = 5
    
    transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
    dropDownTableView.reloadData()
    
    let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
    transparentView.addGestureRecognizer(tapgesture)
    transparentView.alpha = 0
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0,
                   initialSpringVelocity: 1.0, options: .curveEaseInOut, animations:{
                    self.transparentView.alpha = 0.5
                    self.dropDownTableView.frame = CGRect(x: frames.origin.x,
                                                          y: frames.origin.y + frames.height + 5,
                                                          width: frames.width,
                                                          height:
                                                            CGFloat(self.dropdownDataSource.dataList.count * 50))
                   }, completion: nil)
  }
  
  @objc func removeTransparentView() {
    let frames = selectedButton.frame
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0,
                   initialSpringVelocity: 1.0, options: .curveEaseInOut, animations:{
                    self.transparentView.alpha = 0.0
                    self.dropDownTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y,
                                                          width: frames.width, height: 0)
                   }, completion: nil)
  }
  
  @IBAction func didTapSetOrderButton(_ sender: UIButton) {
    selectedButton = setOrderButton
    addTransparentView(frames: setOrderButton.frame)
  }
  
  @IBAction func didTapFilterButton(_ sender: UIButton) {
    let bundle = Bundle(identifier: "P.TEP.jjollaejjollae")
    let filterStoryboard = UIStoryboard(name: "Filter", bundle: bundle )
    guard let filterVC = filterStoryboard.instantiateViewController(
            identifier: "FilterViewController") as? FilterViewController else {return}
    //    self.navigationController?.pushViewController(filterVC, animated: true)
    self.navigationController?.present(filterVC, animated: true, completion: nil)
    // completion에서 data 보내줘야함
  }
}

//MARK: - tableviewDelegate

extension SearchResultViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView == dropDownTableView {
      guard var oldValue = selectedButton.currentTitle else {
        return
      }
      oldValue = String(oldValue.dropLast(2))
      selectedButton.setTitle("\(dropdownDataSource.dataList[indexPath.row]) ▼", for: .normal)
      dropdownDataSource.dataList.remove(at: indexPath.row)
      dropdownDataSource.dataList.append(oldValue)
      removeTransparentView()
    }
  }
}


