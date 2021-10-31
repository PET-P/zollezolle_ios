//
//  SearchResultViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/16.
//

import UIKit
import SwiftyJSON

class SearchNoResultViewController: UIViewController, UITextFieldDelegate,
                                    StoryboardInstantiable{
  
  var newDataList: [SearchResultData] = []
  lazy var likes : [String : Bool] = [:]
  var searchData = [String]()
  var searchKeyword: String = ""
  let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
  let searchResultDataSource = SearchResultDataSource()
  
  //MARK: - OUTLET
  @IBOutlet weak var SearchResultTableView: UITableView!
  @IBOutlet weak var noInfoLabel: UILabel! {
    didSet {
      noInfoLabel.font = .robotoRegular(size: 16)
      noInfoLabel.textColor = .gray03
      noInfoLabel.text = "\"\(SearchManager.shared.searchText)에 해당하는 정보가 없어요\""
    }
  }
  @IBOutlet weak var headerView: UIView! {
    didSet {
      headerView.backgroundColor = .themePaleGreen
    }
  }
  @IBOutlet weak var separatedLine: UIView! {
    didSet {
      separatedLine.backgroundColor = .gray06
    }
  }
  
  private var noInfoLabelText: String = ""{
    didSet {
      noInfoLabel.text = "\(noInfoLabelText)에 해당하는 정보가 없어요"
    }
  }
  @IBOutlet weak var searchTextField: UITextField! {
    didSet {
      searchTextField.setRounded(radius: nil)
      searchTextField.text = SearchManager.shared.searchText
      searchTextField.delegate = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    SearchResultTableView.delegate = self
    SearchResultTableView.register(nib, forCellReuseIdentifier: "resultCell")
    SearchResultTableView.rowHeight = UITableView.automaticDimension
    if #available(iOS 15.0, *) {
     SearchResultTableView.sectionHeaderTopPadding = 0
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // indicator 띄우기
    let currentLocation = UserManager.shared.locationService.currentLocation
    let lng = currentLocation.longitude
    let lat = currentLocation.latitude
    APIService.shared.nearPlace(latitude: lat, longitude: lng) { [weak self](result) in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        self.newDataList = data
        self.searchResultDataSource.newDataList = self.newDataList
        self.SearchResultTableView.dataSource = self.searchResultDataSource
        // indicator 끄기
      case .failure(let error):
        print("error \(error)")
      }
    }
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    gotoSearchVC(from: self)
  }
}

//MARK: - keybaord & search

extension SearchNoResultViewController {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    gotoSearchVC(from: self)
  }
}

extension SearchNoResultViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
    let headerLabel = UILabel()
    headerLabel.frame = CGRect(x: 16, y: 37, width: header.frame.width-16, height: 21)
    headerLabel.text = "근처 장소를 소개해드릴게요"
    headerLabel.font = .robotoBold(size: 18)
    headerLabel.textColor = UIColor.색44444
    header.backgroundColor = .white
    header.addSubview(headerLabel)
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 80
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.bounces = scrollView.contentOffset.y > 0
  }
  
  /**
   Cell 을 탭했을때, 상세페이지/장소 화면을 띄워준다
   - Author: 박우찬
   */
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let placeId = newDataList[indexPath.row].id
    
    LoadingIndicator.show()
    
    APIService.shared.fetchPlaceInfo(placeId: placeId) { result in
      
      switch result {
        case .success(let data):
          
          guard let vc = PlaceDetailTableViewController.loadFromStoryboard() as? PlaceDetailTableViewController else { return }
          
          let data = JSON(data)
          
          let placeInfo = PlaceInfo.init(placeID: placeId, json: data)
          
          vc.placeInfo = placeInfo
          
        self.navigationController?.pushViewController(vc, animated: true) {
          LoadingIndicator.hide()
        }
          
        case .failure(let statusCode):
          print(statusCode)
          LoadingIndicator.hide()
      }
    }
  }
  
}

extension SearchNoResultViewController: SearchDataReceiveable {
  func returnHeart(placeId: String) {
    
    var returnHeartIndex = 0
    for index in newDataList.indices {
      if newDataList[index].id == placeId {
        likes[placeId] = false
        newDataList[index].isWish = false
        returnHeartIndex = index
        return
      }
    }
    
    SearchResultTableView.beginUpdates()
    SearchResultTableView.reloadRows(at: [IndexPath(row: returnHeartIndex, section: 0)], with: .none)
    SearchResultTableView.endUpdates()
    
  }
}
