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
      numberOfResultLabel.text = "0개의 숙소"
      numberOfResultLabel.font = .robotoRegular(size: 12)
      numberOfResultLabel.textColor = .색44444
    }
  }
  @IBOutlet var setOrderButton: UIButton! {
    didSet {
      setOrderButton.layer.borderWidth = 0
      setOrderButton.setTitle("리뷰 많은순▼", for: .normal)
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
  lazy var region = "제주"
  private var filter: String = "리뷰 많은순" {
    didSet {
      if restaurantButton.isSelected {
        APIService.shared.getFilterPlace(region: region, category: .restaurant, filter: filter, page: 0) { [weak self](result) in
          guard let self = self else {return}
          switch result {
          case .success(let data):
            self.fetchDatasource(paging: false, category: .restaurant, with: data)
          case .failure(let error):
            print(self,#function, error)
          }
        }
      } else if landMarkButton.isSelected {
        APIService.shared.getFilterPlace(region: region, category: .landmark, filter: filter, page: 0) { (result) in
          switch result {
          case .success(let data):
            self.fetchDatasource(paging: false, category: .landmark, with: data)
          case .failure(let error):
            print(self,#function, error)
          }
        }
      } else if cafeButton.isSelected {
        APIService.shared.getFilterPlace(region: region, category: .cafe, filter: filter, page: 0) { (result) in
          switch result {
          case .success(let data):
            self.fetchDatasource(paging: false, category: .cafe, with: data)
          case .failure(let error):
            print(self,#function, error)
          }
        }
      } else {
        APIService.shared.getFilterPlace(region: region, category: .accommodation, filter: filter, page: 0) { (result) in
          switch result {
          case .success(let data):
            self.fetchDatasource(paging: false, category: .accommodation, with: data)
          case .failure(let error):
            print(self,#function, error)
          }
        }
      }
    }
  }
  
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
  
  private var mode: Mode = .Fromlocation
  
  func setMode(from viewController: UIViewController) {
    let text = SearchManager.shared.searchText
    switch text {
    case "카페", "맛집", "레스토랑", "숙소", "명소", "관광지":
      self.mode = .Fromkeyword
    default:
      if viewController is SearchWithLocationViewController {
        self.mode = .Fromlocation
        self.region = SearchManager.shared.searchText
      } else {
        self.mode = .Fromsearch
      }
    }
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    LoadingIndicator.show()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      LoadingIndicator.hide()
    }
  }
  
  
  //MARK: - resultTableView setup
  private func setupReviewTableView() {
    resultTableView.delegate = self
    resultTableView.register(nib, forCellReuseIdentifier: "resultCell")
    resultTableView.isUserInteractionEnabled = true
    if mode == .Fromlocation {
      accommodationDataSource.setCallerVC(viewController: self)
      restaurantDataSource.setCallerVC(viewController: self)
      landmarkDataSource.setCallerVC(viewController: self)
      cafeDataSource.setCallerVC(viewController: self)
      searchResultDataSources = [accommodationDataSource,
                                 restaurantDataSource,
                                 cafeDataSource,
                                 landmarkDataSource]
      accommodationDataSource.newDataList = self.newDataList
      self.dataList = accommodationDataSource.newDataList
    } else {
      searchResultDataSource.setCallerVC(viewController: self)
      searchResultDataSource.newDataList = newDataList
      self.dataList = searchResultDataSource.newDataList
      searchResultDataSources = [searchResultDataSource]
    }
    resultTableView.dataSource = searchResultDataSources[0]
    resultTableView.tableFooterView = UIView(frame: CGRect.zero)
    resultTableView.separatorStyle = .none
    numberOfResultLabel.text = "고쳐야할개의 숙소"
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
//      resultTableView.sectionHeaderTopPadding = 0
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
      button.setTitleColor(.gray01, for: .selected)
      button.setTitleColor(.gray01, for: .normal)
      if button == sender {
        button.backgroundColor = .themePaleGreen
        button.tintColor = .themePaleGreen
        button.isSelected = true
      } else {
        button.backgroundColor = .white
        button.tintColor = .white
        button.isSelected = false
      }
    }
  }
  
  private func updateSelected(_ sender: UIButton){
    let buttons = [restaurantButton, landMarkButton, accommodationButton, cafeButton]
    for button in buttons {
      if sender == button{
        button?.isSelected = true
      } else {
        button?.isSelected = false
      }
    }
  }
  
  @IBAction private func didTapFilterButtons(_ sender: UIButton) {
    //초기화작업
    page = 0
    self.dataList = []
    resultTableView.reloadData()
    updateSelected(sender)
    switch sender {
    case restaurantButton:
      
      resultTableView.dataSource = searchResultDataSources[1]
      APIService.shared.getFilterPlace(region: region, category: .restaurant, filter: filter, page: 0) { [weak self](result) in
        guard let self = self else {return}
        switch result {
        case .success(let data):
          self.fetchDatasource(paging: false, category: .restaurant, with: data)
        case .failure(let error):
          print(self,#function, error)
        }
      }
    case landMarkButton:
      resultTableView.dataSource = searchResultDataSources[3]
      APIService.shared.getFilterPlace(region: region, category: .landmark, filter: filter, page: 0) { [weak self](result) in
        guard let self = self else {return}
        switch result {
        case .success(let data):
          self.fetchDatasource(paging: false, category: .landmark, with: data)
        case .failure(let error):
          print(self,#function, error)
        }
      }
    case cafeButton:
      resultTableView.dataSource = searchResultDataSources[2]
      APIService.shared.getFilterPlace(region: region, category: .cafe, filter: filter, page: 0) { (result) in
        switch result {
        case .success(let data):
          self.fetchDatasource(paging: false, category: .cafe, with: data)
        case .failure(let error):
          print(self,#function, error)
        }
      }
    case accommodationButton:
      resultTableView.dataSource = searchResultDataSources[0]
      APIService.shared.getFilterPlace(region: region, category: .accommodation, filter: filter, page: 0) { (result) in
        switch result {
        case .success(let data):
          self.fetchDatasource(paging: false, category: .accommodation, with: data)
        case .failure(let error):
          print(self,#function, error)
        }
      }
    default:
      return
    }
    updateButtonUI(sender)
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
    
    let reviewAction = UIAlertAction(title: "리뷰 많은순", style: .default) {
      [weak self] result in self?.setOrderButton.setTitle("리뷰 많은순▼", for: .normal)
      self?.filter = "리뷰 많은순"
    }
    let recentAction = UIAlertAction(title: "최근 등록순", style: .default) { [weak self] result in
      self?.setOrderButton.setTitle("최근 등록순▼", for: .normal)
      self?.filter = "최근 등록순"
    }
    let starAction = UIAlertAction(title: "별점 높은순", style: .default) { [weak self] result in
      self?.setOrderButton.setTitle("별점 높은순▼", for: .normal)
      self?.filter = "별점 높은순"
    }
    let subview = alertController.view.subviews.first! as UIView
    let alertContentView = subview.subviews.first! as UIView
    alertContentView.setRounded(radius: 10)
    alertContentView.overrideUserInterfaceStyle = .light
    alertContentView.backgroundColor = UIColor.white
    alertController.view.setRounded(radius: 10)
    alertController.view.tintColor = .themeGreen
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
  
  private func fetchDatasource(paging: Bool, category: CategoryType, with data: [SearchResultData]) {
    if paging {
      self.newDataList += data
    } else {
      self.newDataList = data
    }
    switch category {
    case .accommodation:
      self.accommodationDataSource.newDataList = self.newDataList
      self.dataList = self.accommodationDataSource.newDataList
      self.resultTableView.reloadData()
    case .cafe:
      self.cafeDataSource.newDataList = self.newDataList
      self.dataList = self.cafeDataSource.newDataList
      self.resultTableView.reloadData()
    case .landmark:
      self.landmarkDataSource.newDataList = self.newDataList
      self.dataList = self.landmarkDataSource.newDataList
      self.resultTableView.reloadData()
    case .restaurant:
      self.restaurantDataSource.newDataList = self.newDataList
      self.dataList = self.restaurantDataSource.newDataList
      self.resultTableView.reloadData()
    case .unknown:
      return
    }
    
  }
  
  private func fetchData(){
    fetchMore = false
    page += 1
    if mode == .Fromlocation {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
        guard let self = self else {return}
        if self.restaurantButton.isSelected {
          APIService.shared.getFilterPlace(region: self.region, category: .restaurant, filter: self.filter, page: self.page) { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
              if data.count == 0 {
                print("데이터없음")
                self.fetchMore = false
                return
              }
              self.fetchDatasource(paging: true, category: .restaurant, with: data)
            case .failure(let error):
              print(self,#function, error)
            }
          }
        } else if self.landMarkButton.isSelected {
          APIService.shared.getFilterPlace(region: self.region, category: .landmark, filter: self.filter, page: self.page) { (result) in
            switch result {
            case .success(let data):
              print(data)
              if data.count == 0 {
                print("데이터없음")
                self.fetchMore = false
                return
              }
              self.fetchDatasource(paging: true, category: .landmark, with: data)
            case .failure(let error):
              print(self,#function, error)
            }
          }
        } else if self.cafeButton.isSelected {
          APIService.shared.getFilterPlace(region: self.region, category: .cafe, filter: self.filter, page: self.page) { (result) in
            switch result {
            case .success(let data):
              print(data)
              if data.count == 0 {
                print("데이터없음")
                self.fetchMore = false
                return
              }
              self.fetchDatasource(paging: true, category: .cafe, with: data)
            case .failure(let error):
              print(self,#function, error)
            }
          }
        } else {
          APIService.shared.getFilterPlace(region: self.region, category: .accommodation, filter: self.filter, page: self.page) { (result) in
            switch result {
            case .success(let data):
              print(data)
              if data.count == 0 {
                print("데이터없음")
                self.fetchMore = false
                return
              }
              self.fetchDatasource(paging: true, category: .accommodation, with: data)
            case .failure(let error):
              print(self,#function, error)
            }
          }
        }
        self.fetchMore = true
      }
    } else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
        guard let self = self else {return}
        if let token = UserManager.shared.userIdandToken?.token {
          APIService.shared.search(token: token, keyword: SearchManager.shared.searchText, page: self.page) { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
              if data.result.count == 0 {
                print("데이터없음")
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
        } else {
          APIService.shared.search(keyword: SearchManager.shared.searchText, page: self.page) { [weak self](result) in
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
        self.fetchMore = true
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




