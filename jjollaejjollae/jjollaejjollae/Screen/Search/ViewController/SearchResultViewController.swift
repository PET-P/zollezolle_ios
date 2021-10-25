//
//  SearchResultViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

enum Mode {
  case Fromkeyword
  case Fromlocation
  case Fromsearch
}


class SearchResultViewController: UIViewController, StoryboardInstantiable, SearchDataReceiveable {
  
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
      setFilterButton.isHidden = true
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
  
  
  var newDataList: [SearchResultData] = []
  lazy var likes: [Int : Int] = [:]
  private var fetchMore = true
  private var page = 0
  
  private var dataList = [SearchResultData]()
  private var accomoList = [SearchResultData]()
  private var cafeList = [SearchResultData]()
  private var restaurantList = [SearchResultData]()
  private var landmarkList = [SearchResultData]()
  
  let accommodationDataSource = AccommodationDataSource()
  let restaurantDataSource = RestaurantDataSource()
  let cafeDataSource = CafeDataSource()
  let landmarkDataSource = LandmarkDataSource()
  let searchResultDataSource = SearchResultDataSource()
  
  let searchManager = SearchManager.shared
  private var defaultHeight: CGFloat  = 13
  private var buttons : [UIButton] = []
  private let transparentView = UIView()
  private var selectedButton = UIButton()
  private let headerHeight: CGFloat = 60
  
  private var mode: Mode = .Fromlocation  // true: 지역검색후 넘어오는 화면, false: 카페라고만 치는 경우
  
  func setMode(from viewController: UIViewController) {
    let text = SearchManager.shared.searchText
    switch text {
    case "카페", "맛집", "레스토랑", "숙소", "명소", "관광지":
      self.mode = .Fromkeyword
    default:
      if viewController is SearchWithLocationViewController {
        self.mode = .Fromlocation
      } else {
        self.mode = .Fromsearch
      }
    }
  }
  
  private func categorizeSearchResult() {
  
    newDataList.forEach { (data) in
      switch data.category {
      case .accommodation:
        accomoList.append(data)
      case .cafe:
        cafeList.append(data)
      case .restaurant:
        restaurantList.append(data)
      case .landmark:
        landmarkList.append(data)
      case .unknown:
        return
      }
    }
    accommodationDataSource.newDataList = accomoList
    cafeDataSource.newDataList = cafeList
    restaurantDataSource.newDataList = restaurantList
    landmarkDataSource.newDataList = landmarkList
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLocationFilterButtonUI()
    updatedModeUI()
    setupReviewTableView()
    if mode != .Fromlocation {
      setupheader()
    }
    searchTextField.text = searchManager.searchText
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
    if mode == .Fromlocation {
      categorizeSearchResult()
      accommodationDataSource.setCallerVC(viewController: self)
      restaurantDataSource.setCallerVC(viewController: self)
      landmarkDataSource.setCallerVC(viewController: self)
      cafeDataSource.setCallerVC(viewController: self)
      searchResultDataSources = [accommodationDataSource,
                                 restaurantDataSource,
                                 cafeDataSource,
                                 landmarkDataSource]
      self.dataList = accommodationDataSource.newDataList
    } else {
      searchResultDataSource.newDataList = newDataList
      self.dataList = searchResultDataSource.newDataList
      searchResultDataSources = [searchResultDataSource]
    }
    resultTableView.dataSource = searchResultDataSources[0]
    resultTableView.tableFooterView = UIView(frame: CGRect.zero)
    resultTableView.separatorStyle = .none
  }
  
  private func setupheader() {
      let header = UIView(frame: CGRect(x: 0, y: 0, width: resultTableView.frame.width, height: 40))
      let headerLabel = UILabel()
      headerLabel.translatesAutoresizingMaskIntoConstraints = false
      if mode == .Fromkeyword {
        headerLabel.text = "내 근처 \(self.searchTextField.text == "" ? "갈만한 곳" : self.searchTextField.text ?? "갈만한 곳")"
      } else {
        headerLabel.text = "검색 결과"
      }
      
      headerLabel.font = .robotoBold(size: 18)
      headerLabel.textColor = .gray02
      header.backgroundColor = .white
      header.addSubview(headerLabel)
      
      headerLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16).isActive = true
      headerLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 6).isActive = true
    resultTableView.tableHeaderView = header
    if #available(iOS 15.0, *) {
      resultTableView.sectionHeaderTopPadding = 0
    }
  }

  private func updatedModeUI() {
    if mode == .Fromlocation {
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
      dataList = restaurantDataSource.newDataList
    case landMarkButton:
      resultTableView.dataSource = searchResultDataSources[3]
      dataList = landmarkDataSource.newDataList
    case cafeButton:
      resultTableView.dataSource = searchResultDataSources[2]
      dataList = cafeDataSource.newDataList
    case accommodationButton:
      resultTableView.dataSource = searchResultDataSources[0]
      dataList = accommodationDataSource.newDataList
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
  
}

//MARK: - tableviewDelegate

extension SearchResultViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
  }
  
  private func fetchData(){
    fetchMore = false
    if let token = UserManager.shared.userIdandToken?.token {
      page = page + 1
      APIService.shared.search(token: token, keyword: SearchManager.shared.searchText, page: page) { [weak self](result) in
        guard let self = self else {return}
        switch result {
        case .success(let data):
          if data.result.count == 0 {
            self.fetchMore = false
            return
          }
          self.newDataList += data.result
          self.searchResultDataSource.newDataList = self.newDataList
          self.dataList = self.searchResultDataSource.newDataList
          self.resultTableView.reloadData()
        case .failure(let error):
          print("error: \(error)")
        }
      }
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.bounces = scrollView.contentOffset.y > 0
    if resultTableView.contentOffset.y > resultTableView.contentSize.height - resultTableView.bounds.height {
      print("끝에 도착했다!!!")
      if fetchMore {
        fetchData()
      }
    }
  }
}

//MARK: - KEYBOARD
extension SearchResultViewController: UITextFieldDelegate, Searchable {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    gotoSearchVC(from: self)
  }
}




