//
//  MyInfoReviewViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/06.
//

import UIKit

protocol ListItem {
  var isPhotoItem0: Bool {get}
  var isPhotoItem1: Bool {get}
  var isPhotoItem2: Bool {get}
  //  var isPhotoItem3: Bool {get}
  //  var isPhotoItem4: Bool {get}
}

protocol TableCellController {
  static func registerCell(on tableView: UITableView)
  func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell
  func didSelectCell()
}

class OnePhotoCellController: TableCellController {
  
  fileprivate let item: ListItem
  
  init(item: ListItem) {
    self.item = item
  }
  
  fileprivate static var cellIdentifier: String {
    return String(describing: type(of: ReviewTableCell.self))
  }
  
  static func registerCell(on tableView: UITableView) {
    tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: ReviewTableCell.self)), forCellReuseIdentifier: cellIdentifier)
  }
  
  func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath) as! ReviewTableCell
    
    
    return cell
  }
  
  func didSelectCell() {
    //TODO: 아무것도 사실 없다.
  }
}

class TwoPhotoCellController: TableCellController {
  
  fileprivate let item: ListItem
  
  init(item: ListItem) {
    self.item = item
  }
  
  fileprivate static var cellIdentifier: String {
    return String(describing: type(of: ReviewTableCell.self))
  }
  
  static func registerCell(on tableView: UITableView) {
    tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: ReviewTableCell.self)), forCellReuseIdentifier: cellIdentifier)
  }
  
  func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath) as! ReviewTableCell
    
    
    return cell
  }
  
  func didSelectCell() {
    //TODO: 아무것도 사실 없다.
  }
}

class TextCellController: TableCellController {
  
  fileprivate let item: ListItem
  
  init(item: ListItem) {
    self.item = item
  }
  
  fileprivate static var cellIdentifier: String {
    return String(describing: type(of: ReviewTableCell.self))
  }
  
  static func registerCell(on tableView: UITableView) {
    tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: ReviewTableCell.self)), forCellReuseIdentifier: cellIdentifier)
  }
  
  func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath) as! ReviewTableCell
    
    
    return cell
  }
  
  func didSelectCell() {
    //TODO: 아무것도 사실 없다.
  }
}

class MyCellControllerFactory {
  func registerCells(on tableView: UITableView) {
    OnePhotoCellController.registerCell(on: tableView)
    TwoPhotoCellController.registerCell(on: tableView)
  }
  
  func cellControllers(with items: [ListItem]) -> [TableCellController] {
    return items.map({ item in
      if item.isPhotoItem1 {
        return OnePhotoCellController(item: item)
      } else if item.isPhotoItem2 {
        return TwoPhotoCellController(item: item)
      } else {
        return TextCellController(item: item)
      }
    })
  }
}


class MyInfoReviewViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.textColor = .gray03
    }
  }
  
  @IBOutlet var subtitle: [UILabel]! {
    didSet {
      subtitle.forEach { (sub) in
        sub.textColor = .gray03
      }
    }
  }
  @IBOutlet weak var reviewTableView: UITableView! {
    didSet {
      reviewTableView.delegate = self
      reviewTableView.dataSource = self
    }
  }
  @IBOutlet weak var headerView: UIView!
  
  @IBOutlet weak var navLabel: UILabel! {
    didSet {
      navLabel.font = .robotoBold(size: 20)
      navLabel.textColor = .gray01
    }
  }
  @IBOutlet weak var reviewNumLabel: UILabel! {
    didSet {
      reviewNumLabel.text = "총 0개의 후기"
      reviewNumLabel.textColor = .gray01
      reviewNumLabel.font = .robotoBold(size: 18)
    }
  }
  
  @IBOutlet weak var helpNumLabel: UILabel! {
    didSet {
      helpNumLabel.text = "0개의 도움돼요"
      helpNumLabel.textColor = .gray03
      helpNumLabel.font = .robotoBold(size: 11)
    }
  }
  
  @IBOutlet weak var separateLine: UIView! {
    didSet {
      separateLine.backgroundColor = .gray06
    }
  }
  
  private var reviewNumber: Int = 0 {
    didSet {
      reviewNumLabel.text = "총 \(reviewNumber)개의 후기"
    }
  }
  
  private var helpNumber: Int = 0 {
    didSet {
      helpNumLabel.text = "\(helpNumber)개의 도움돼요"
    }
  }
  
  private var starImageList: [UIImage] = []
  private var myReviews: [ReviewData] = []
  private var reviewAndImageArray: [(review: ReviewData, images: [UIImage])] = []
  private var token: String = ""
  private var userId: String = ""
  private var imageList: [UIImage] = []
  private var defaultImage: UIImage = UIImage(named: "IMG_4930")!
  private var dispatchGroup = DispatchGroup()
  
  //  fileprivate var cellControllers = [TableCellController]()
  //  fileprivate let cellControllerFactory = MyCellControllerFactory()
  
  internal func getTokenAndUserId(token: String, userId: String) {
    self.token = token
    self.userId = userId
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(deleteReview(_:)), name: NSNotification.Name("deleteReviewNotification"), object: nil)
    dispatchGroup.enter()
    setupReviews()
    reviewTableView.register(UINib(nibName: ReviewTableCell.nibName, bundle: nil), forCellReuseIdentifier: "reviewCell")
    
    
    for i in 1...5 {
      starImageList.append(UIImage(named: "star\(i)")!)
    }
  }
  
  // 지우고 바로 다음 즉시 업데이트가 안됨 이유는?
  @objc func deleteReview(_ notification: NSNotification) {
    guard let deleteReviewIndex: Int = notification.userInfo?["index"] as? Int else {return}
    guard let deleteReviewId: String = notification.userInfo?["reviewId"] as? String else {return}
    guard let token = UserManager.shared.userIdandToken?.token else {return}
    APIService.shared.deleteReview(token: token, reviewId: deleteReviewId) { [weak self] (result) in
      guard let self = self else {return}
      switch result {
      case .success:
        print("성공")
        self.setupReviews()
      case .failure(let error):
        print(error)
      }
    }
  }
  
  private func setupReviews() {
    APIService.shared.readReview(token: token, userId: userId) { [weak self] (result) in
      guard let self = self else {return}
      switch result {
      case .success(let data):
        self.reviewNumber = data.totalReview
        self.helpNumber = data.totalLike
        self.myReviews = data.reviews
        if self.myReviews.count == 0 {
          self.reviewTableView.alpha = 0
          self.reviewNumber = 0
          self.helpNumber = 0
          return
        }
        for myReview in self.myReviews {
          var tempVal: (review: ReviewData, images: [UIImage]) = (myReview, [])
          for imageURL in myReview.imagesURL {
            StorageService.shared.downloadUIImageWithURL(with: imageURL) { (image) in
              if let image = image {
                tempVal.images.append(image)
              } else {
                tempVal.images.append(self.defaultImage)
              }
            }
          }
          self.reviewAndImageArray.append(tempVal)
        }
        self.dispatchGroup.leave()
      case .failure(let error):
        // 없다는 이야기
        self.reviewTableView.alpha = 0
        self.reviewNumber = 0
        self.helpNumber = 0
      }
    }
    dispatchGroup.notify(queue: .main) { [weak self] in
      self?.reviewTableView.reloadData()
      self?.reviewAndImageArray.forEach({ (result) in
        print(result.images)
      })
    }
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension MyInfoReviewViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviewAndImageArray.count
  }
  
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewTableCell else {return UITableViewCell()}
    let item = reviewAndImageArray[indexPath.row].review
    let images = reviewAndImageArray[indexPath.row].images
    
    cell.starImageView.image = starImageList[item.point - 1]
    
    cell.thumbLabel.helpNumber = item.likeCnt[0]
    cell.hundredLabel.helpNumber = item.likeCnt[1]
    cell.heartLabel.helpNumber = item.likeCnt[2]
    
    cell.reviewLabel.text = item.text
    cell.reviewId = item.id
    cell.reviewIndex = indexPath.row
    
    cell.dateLabel.text = item.createdAt.components(separatedBy: "T").first!
    cell.titleLabel.text = item.place.title
    if item.imagesURL.count == 0 {
      cell.reviewImageView.isHidden = true
    } 
    let satisfactionFactor: [String] = item.satisfaction
    for tag in cell.tags {
      if !satisfactionFactor.contains(tag.currentTitle!){
        tag.isHidden = true
      }
    }
    
    return cell
  }
}
