//
//  SearchResultViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

class CellClass: UITableViewCell {
  
}

//MARK: - 임시로 모델만들기
class ModelController: NSObject {
  var accommoList = [SearchResultInfo(name: "여기는 숙소"), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(),]
  var cafeList = [SearchResultInfo(name: "여기는 카페"), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(),]
  var landmarkList = [SearchResultInfo(name: "여기는 관광지"), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(),]
  var restaurantList = [SearchResultInfo(name: "여기는 맛집"), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(), SearchResultInfo(),]
}

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
  @IBOutlet weak var restaurantButton: UIButton!
  @IBOutlet weak var landMarkButton: UIButton!
  @IBOutlet weak var cafeButton: UIButton!
  @IBOutlet weak var accommodationButton: UIButton!
  @IBOutlet weak var setScheduleButton: UIButton! {
    didSet {
      setScheduleButton.setRounded(radius: 4)
      setScheduleButton.backgroundColor = UIColor(rgb: 0xF4F4F4)
      setScheduleButton.setTitle("8월 10일 (화) - 8월 14일 (토)", for: .normal)
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
  
  
  let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
  var searchResultDataSources: [UITableViewDataSource] = []
  var dataList = [SearchResultInfo]()
  lazy var likes: [Int : Int] = [:]
  
  let accommodationDataSource = AccommodationDataSource()
  let restaurantDataSource = RestaurantDataSource()
  let cafeDataSource = CafeDataSource()
  let landmarkDataSource = LandmarkDataSource()
  let dropdownDataSource = DropDownDataSource()
  
  let modelController = ModelController()
  var defaultHeight: CGFloat  = 0
  var buttons : [UIButton] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resultTableView.delegate = self
    dropDownTableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    resultTableView.register(nib, forCellReuseIdentifier: "resultCell")
    accommodationDataSource.dataList = modelController.accommoList
    restaurantDataSource.dataList = modelController.restaurantList
    cafeDataSource.dataList = modelController.cafeList
    landmarkDataSource.dataList = modelController.landmarkList
    searchResultDataSources = [accommodationDataSource, restaurantDataSource, cafeDataSource, landmarkDataSource]
    resultTableView.dataSource = searchResultDataSources[0]
    resultTableView.tableFooterView = UIView(frame: CGRect.zero)
    dropDownTableView.dataSource = dropdownDataSource
//    dropDownTableView.contentInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    dropDownTableView.separatorStyle = .none
    dropDownTableView.delegate = self
    setLocationFilterButtonUI()
    defaultHeight = HeightTobeDynamioc.constant
  }
  
  private func setLocationFilterButtonUI() {
    buttons = [restaurantButton, landMarkButton, cafeButton, accommodationButton]
    buttons.forEach { (button) in
      button.setRounded(radius: nil)
      button.layer.borderColor = UIColor.쫄래페일그린.cgColor
      button.layer.borderWidth = 1.0
      button.backgroundColor = .white
      button.tintColor = .쫄래블랙
      button.titleLabel?.font = .robotoMedium(size: 13)
    }
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
  
  @IBAction private func didTapRestaurantButton(_ sender: UIButton) {
    resultTableView.dataSource = searchResultDataSources[1]
    scheduleStackView.isHidden = true
    HeightTobeDynamioc.constant = 0 - setFilterButton.frame.height
    updateButtonUI(sender)
    resultTableView.reloadData()
  }
  @IBAction private func didTapLandmarkButton(_ sender: UIButton) {
    resultTableView.dataSource = searchResultDataSources[3]
    scheduleStackView.isHidden = true
    HeightTobeDynamioc.constant = 0 - setFilterButton.frame.height
    updateButtonUI(sender)
    resultTableView.reloadData()
  }
  @IBAction private func didTapCafeButton(_ sender: UIButton) {
    resultTableView.dataSource = searchResultDataSources[2]
    scheduleStackView.isHidden = true
    print(setFilterButton.frame.height)
    print(HeightTobeDynamioc.constant)
    HeightTobeDynamioc.constant = 0 - setFilterButton.frame.height
    updateButtonUI(sender)
    resultTableView.reloadData()
  }
  @IBAction private func didTapAccommodationButton(_ sender: UIButton) {
    resultTableView.dataSource = searchResultDataSources[0]
    scheduleStackView.isHidden = false
    HeightTobeDynamioc.constant = defaultHeight
    updateButtonUI(sender)
    resultTableView.reloadData()
  }
  
  let transparentView = UIView()
  let dropDownTableView = UITableView()
  
  var selectedButton = UIButton()
  
  func addTransparentView(frames: CGRect) {
    let window = UIApplication.shared.windows.first {$0.isKeyWindow}
    transparentView.frame = window?.frame ?? self.view.frame
    view.addSubview(transparentView)
    
    dropDownTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
    view.addSubview(dropDownTableView)
    dropDownTableView.layer.cornerRadius = 5
    
    transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
    dropDownTableView.reloadData()
    
    let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
    transparentView.addGestureRecognizer(tapgesture)
    transparentView.alpha = 0
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations:{
      self.transparentView.alpha = 0.5
      self.dropDownTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dropdownDataSource.dataList.count * 50))
    }, completion: nil)

  }
  
  @objc func removeTransparentView() {
    let frames = selectedButton.frame
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations:{
      self.transparentView.alpha = 0.0
      self.dropDownTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y, width: frames.width, height: 0)
    }, completion: nil)
  }
  
  @IBAction func didTapSetOrderButton(_ sender: UIButton) {
    selectedButton = setOrderButton
    addTransparentView(frames: setOrderButton.frame)
  }
}

extension SearchResultViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if tableView == resultTableView {
      return tableView.frame.width / 343 * 245
    } else {
      return CGFloat(50)
    }
  }
  
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


