//
//  SearchResultViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/16.
//

import UIKit
import SwiftyJSON

class SearchNoResultViewController: UIViewController, UITextFieldDelegate, Searchable, SearchDataReceiveable,
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
      noInfoLabel.text = "\"멍멍이카페에 해당하는 정보가 없어요\""
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
//      SearchResultTableView.sectionHeaderTopPadding = 0
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // indicator 띄우기
    APIService.shared.nearPlace(latitude: 37.526986862211146, longitude: 126.92225852592222) { [weak self](result) in
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//    guard let token = UserManager.shared.userIdandToken?.token else { return }
    
    let placeId = newDataList[indexPath.row].id
    
    APIService.shared.fetchPlaceInfo(placeId: placeId) { result in
      
      switch result {
        case .success(let data):
          
          let data = JSON(data)
          
          let address = data["address"].arrayValue.reduce("") { result, innerData in
            
            if result.isEmpty {
              return result + innerData.stringValue
            }
            
            return result + " " + innerData.stringValue
          }
          
          let title = data["title"].stringValue
          
          let imageUrls: [String] = data["imagesUrl"].arrayValue.map {
            $0.stringValue
          }
          
          let phone = data["phone"].stringValue
          
          let description = data["description"].stringValue
          
          let category = data["category"].stringValue
          
          let reviewPoint = data["reviewPoint"].intValue
          let reviewCount = data["reviewCount"].intValue
          
          let location: [Double] = data["location"]["coordinates"].arrayValue.map {
            $0.doubleValue
          }
          
//          "reviews": [
//                {
//                  "_id": "61780b16397e22746ae71046",
//                  "point": 4,
//                  "imagesUrl": [
//                    "asfhjaklsfdjlkasdjflkasjf"
//                  ],
//                  "text": "커피가 써요!",
//                  "createdAt": "2021-10-26T14:05:10.236Z",
//                  "nick": "test"
//                }
//              ]
          var reviewList: [Review] = []
          
          for reviewData in data["reviews"].arrayValue {
            
            let id = reviewData["_id"].stringValue
            let point = reviewData["point"].intValue
            let imageUrl = reviewData["imagesUrl"].arrayValue.map {
              $0.stringValue
            }
            let text = reviewData["text"].stringValue
            let createdAt = reviewData["createdAt"].stringValue
            let nick = reviewData["nick"].stringValue
            
            let review = Review(id: id, point: point, imageURLs: imageUrls, text: text, createdAt: createdAt, nickname: nick)
            
            reviewList.append(review)
          }
          
          var reviewCollection: ReviewListDataType = ReviewCollection(value: reviewList)
          
          guard let vc = PlaceDetailTableViewController.loadFromStoryboard() as? PlaceDetailTableViewController else { return }
          
          let placeInfo = PlaceInfo(id: placeId, location: location, address: address, imageUrls: imageUrls, title: title, description: description, phone: phone, category: category, reviewList: reviewCollection, reviewPoint: reviewPoint, reviewCount: reviewCount)
          
          vc.placeInfo = placeInfo
          
          self.navigationController?.pushViewController(vc, animated: true)
          
        case .failure(let statusCode):
          print(statusCode)
      }
    }
    
    
    
    print(indexPath)
  }
  
}
