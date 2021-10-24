//
//  MyInfoReviewViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/06.
//

import UIKit

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
      reviewNumLabel.text = "총 17개의 후기"
      reviewNumLabel.textColor = .gray01
      reviewNumLabel.font = .robotoBold(size: 18)
    }
  }
  
  @IBOutlet weak var helpNumLabel: UILabel! {
    didSet {
      helpNumLabel.text = "31개의 도움돼요"
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
  private var reviewAndImageArray: [(review: ReviewData, images: [UIImage?])] = []
  private var token: String = ""
  private var userId: String = ""
  private var imageList: [UIImage] = []
  private var defaultImage: UIImage = UIImage(named: "IMG_4930")!
  
  internal func getTokenAndUserId(token: String, userId: String) {
    self.token = token
    self.userId = userId
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupReviews()
    reviewTableView.register(UINib(nibName: ReviewTableCell.nibName, bundle: nil), forCellReuseIdentifier: "reviewCell")
    NotificationCenter.default.addObserver(self, selector: #selector(deleteReview(_:)), name: NSNotification.Name("deleteReviewNotification"), object: nil)
    for i in 1...5 {
      starImageList.append(UIImage(named: "star\(i)")!)
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
          var tempVal: (review: ReviewData, images: [UIImage?]) = (myReview, [])
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
      case .failure(let error):
        // 없다는 이야기
        self.reviewTableView.alpha = 0
        self.reviewNumber = 0
        self.helpNumber = 0
      }
    }
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func deleteReview(_ noti: Notification) {
    guard let index = noti.object as? Int else {return}
    APIService.shared.deleteReview(reviewId: reviewAndImageArray[index].review.id) { [weak self](result) in
      guard let self = self else {return}
      switch result {
      case .success:
        print("성공")
        self.reviewAndImageArray.remove(at: index)
        self.reviewTableView.reloadData()
      case .failure(let error):
        print(error)
      }
    }
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
    cell.dateLabel.text = item.createdAt.components(separatedBy: "T").first!
    cell.titleLabel.text = item.place.title
    cell.imagesCount = images.count
    
    let satisfactionFactor: [String] = item.satisfaction
    for tag in cell.tags {
      if !satisfactionFactor.contains(tag.currentTitle!){
        cell.tagStackView.removeArrangedSubview(tag)
      }
    }
    cell.reviewIndex = indexPath.row
    return cell
  }
  

  
  
}
