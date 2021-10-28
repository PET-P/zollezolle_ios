//
//  SearchWithLocationViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/26.
//

import UIKit
import SwiftyJSON

class SearchWithLocationViewController: UIViewController, StoryboardInstantiable, UITextFieldDelegate, Searchable, SearchDataReceiveable {
  
  var newDataList: [SearchResultData] = [] {
    didSet {
      newDataList.forEach { (data) in
        likes.updateValue(data.isWish ?? false, forKey: data.id)
      }
    }
  }
  
  @IBOutlet weak var resultTableView: UITableView! {
    didSet {
      resultTableView.delegate = self
      resultTableView.dataSource = self
      resultTableView.register(nib, forCellReuseIdentifier: "resultCell")
      resultTableView.separatorStyle = .none
    }
  }
  
  let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
  private var searchData = [String]()
  private var fetchMore = true
  private var page = 0
  private var region = ""
  lazy var likes: [String : Bool] = [:]
  
  @IBOutlet weak var headView: UIView! {
    didSet {
      headView.backgroundColor = .themePaleGreen
    }
  }
  @IBOutlet weak var searchTextField: UITextField! {
    didSet {
      searchTextField.setRounded(radius: nil)
      //get
      searchTextField.text = SearchManager.shared.searchText
      searchTextField.delegate = self
    }
  }
  @IBOutlet weak var backButton: UIView!
  @IBOutlet weak var headerLabel: UILabel! {
    didSet {
      headerLabel.font = .robotoBold(size: 18)
      headerLabel.textColor = .gray02
    }
  }
  @IBOutlet weak var separateLine: UIView! {
    didSet {
      separateLine.backgroundColor = .gray06
    }
  }
  
  @IBOutlet weak var LocationView: UIImageView! {
    didSet {
      LocationView.image = UIImage(named: "\(region)")
      LocationView.setRounded(radius: 10)
      LocationView.isUserInteractionEnabled = true
    }
  }
  
  @IBOutlet weak var locationLabel: UILabel! {
    didSet {
      locationLabel.text = region
      locationLabel.textColor = .white
      locationLabel.font = .robotoBold(size: 18)
    }
  }
  @IBOutlet weak var locationNumLabel: UILabel! {
    didSet {
      locationNumLabel.text = "178개의 장소"
      locationNumLabel.textColor = .white
      locationNumLabel.font = .robotoMedium(size: 12)
    }
  }
  @IBOutlet weak var notFoundLabel: UILabel! {
    didSet {
      notFoundLabel.font = .robotoRegular(size: 16)
      notFoundLabel.textColor = .gray03
      notFoundLabel.text = "\"멍멍이카페에 해당하는 정보가 없어요\""
    }
  }
  
  private var locationNum = 10
  
  private var notFoundText = "찾으시는 정보가 없습니다." {
    didSet {
      notFoundLabel.text = notFoundText
    }
  }
  
  func setLocationNum(regionCount: Int){
    self.locationNum = regionCount
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resultTableView.isUserInteractionEnabled = true
    searchTextField.text = SearchManager.shared.searchText
    locationNumLabel.text = "\(locationNum)개의 장소"
    if newDataList.count == 0 {
      notFoundText = "\"\(SearchManager.shared.searchText)에 해당하는 정보가 없어요\""
      resultTableView.isHidden = true
    } else {
      notFoundLabel.isHidden = true
    }
    print("😀Test", newDataList)
    setupGesture()
    
  }
  
  func setRegion(region: String){
    self.region = region
  }
  
  private func setupGesture() {
    let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLocationView))
    LocationView.addGestureRecognizer(locationTapGesture)
    
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func didTapLocationView(_ sender: Any?) {
    APIService.shared.getFilterPlace(region: region, category: .accommodation, filter: "리뷰 많은순", page: 0) { [weak self] (result) in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        SearchManager.shared.searchText = self.region
        guard let nextVC = SearchResultViewController.loadFromStoryboard() as? SearchResultViewController else {return}
        nextVC.setMode(from: self)
        nextVC.newDataList = data
        self.navigationController?.pushViewController(nextVC, animated: true)
      case .failure(let error):
        print("error ", error)
      }
    }
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    gotoSearchVC(from: self)
  }
  
}

extension SearchWithLocationViewController: UITableViewDelegate, UITableViewDataSource, SearchResultCellDelegate {
  func didTapHeart(for placeId: String, like: Bool) {
    if like {
      likes[placeId] = true
    } else {
      likes[placeId] = false
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newDataList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell else {return UITableViewCell()}
    cell.delegate = self
    cell.placeId = newDataList[indexPath.row].id
    
    let item = newDataList[indexPath.row]
    
    cell.cellImageView.setImage(with: item.imagesUrl.first ?? "default")
    cell.locationNameLabel.text = item.title
    cell.locationTypeLabel.text = nil
    cell.numberOfReviewsLabel.text = "(\(item.reviewCount))"
    cell.starPointLabel.text = " \(item.reviewPoint ?? 0)"
    
    cell.isWish = likes[cell.placeId] == true
    newDataList[indexPath.row].isWish = likes[cell.placeId] == true //이것의 이유?
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
    let headerLabel = UILabel()
    headerLabel.numberOfLines = 0
    headerLabel.frame = CGRect(x: 16, y: 37, width: header.frame.width-16, height: 21)
    headerLabel.text = "혹시 여기를 찾으셨나요?"
    headerLabel.font = .robotoBold(size: 18)
    headerLabel.textColor = UIColor.색44444
    header.backgroundColor = .white
    header.addSubview(headerLabel)
    return header
  }
  
  /**
   Cell 을 탭했을때, 상세페이지/장소 화면을 띄워준다
   */
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

extension SearchWithLocationViewController {
  
  private func fetchData(){
    fetchMore = false
    page = page+1
    if let token = UserManager.shared.userIdandToken?.token {
      APIService.shared.search(token: token, keyword: SearchManager.shared.searchText, page: page) { [weak self](result) in
        guard let self = self else {return}
        switch result {
        case .success(let data):
          if data.result.count == 0 {
            self.fetchMore = false
            return
          }
          self.newDataList += data.result
          self.resultTableView.reloadData()
        case .failure(let error):
          print("error: \(error)")
        }
      }
    } else {
      APIService.shared.search(keyword: SearchManager.shared.searchText, page: page) { [weak self](result) in
        guard let self = self else {return}
        switch result {
        case .success(let data):
          if data.result.count == 0 {
            self.fetchMore = false
            return
          }
          self.newDataList += data.result
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
