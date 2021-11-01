//
//  AllReviewsTableViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/28.
//

import UIKit

class AllReviewsTableViewController: UITableViewController, StoryboardInstantiable {
  
  var apiService = APIService.shared
  
  var totalReviewList: TotalPlaceReview? {
    
    didSet {
      
      guard totalReviewList != nil else { return }
      
      numOfTotalReviewLabel.text = "총 \(totalReviewList!.numOfTotalReview)개의 후기"
      
      ratingPointLabel.text = String(format: "%.1f", totalReviewList!.avgPoint)
      
      if let sortingOrder = SortingOrder(rawValue: sortingSegmentedControl.selectedSegmentIndex) {
        
        guard let reviews = sortedReviewList(by: sortingOrder)  else { return }
        
        totalReviewList!.reviews = reviews
      }

      tableView.reloadData()
      
    }
  }
  
  @IBOutlet weak var numOfTotalReviewLabel: UILabel!
  
  @IBOutlet weak var ratingPointLabel: UILabel!
  
  @IBOutlet weak var sortingSegmentedControl: UISegmentedControl!
  
  private let dateFormatter: DateFormatter = {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return formatter
    
  }()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    self.navigationItem.backBarButtonItem?.tintColor = .black

  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    
    self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {

      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
    
    guard let numOfTotalReview = totalReviewList?.numOfTotalReview else { return 0 }
    
    return numOfTotalReview
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AllReviewsTableViewCell.identifier, for: indexPath) as? AllReviewsTableViewCell, let reviewList = totalReviewList?.reviews else { return UITableViewCell() }

    let review = reviewList[indexPath.row]

    cell.nickName = review.userNick

    if let imageUrl = review.imagesURL.first {
      cell.photoImageView.setImage(with: imageUrl)
    } else {
      cell.photoImageView.image = nil
    }

    cell.dateText = trimStringDate(with: review.createdAt)
    
    cell.ratingPoint = review.point
    
    cell.descriptionText = review.description
    /**
     [도움돼요] 버튼 숫자
     */
    cell.numOfLikes = review.numOfLikes
    
    /**
     [도움돼요] 버튼 선택 상태
     */
    
    cell.isLikeButtonSelected = review.isLike
    
    
    cell.likeButton.tag = indexPath.row
    
    cell.likeButton.addTarget(self, action: #selector(didTapLikeButton(sender:)), for: .touchUpInside)
    
    cell.reportButton.tag = indexPath.row

    return cell
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(indexPath)
  }
  
  @objc func didTapLikeButton(sender: UIButton) {
    
//    guard var totalReviewList = totalReviewList else { return }
    
    guard let reviewId = totalReviewList?.reviews[sender.tag].id else { return }
    
    guard let token = UserManager.shared.userIdandToken?.token else { return }
    
    guard let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? AllReviewsTableViewCell else { return }
    
    if cell.isLikeButtonSelected {
      apiService.unlikeReview(token: token, reviewId: reviewId) { [weak self] result in
        switch result {
          case .success:
            guard let self = self else { return }
            
            self.totalReviewList?.reviews[sender.tag].isLike = false
            
          case .failure:
            break
        }
      }
    } else {
      apiService.likeReview(token: token, reviewId: reviewId) { [weak self] result in
        
        switch result {
          case .success:
            guard let self = self else { return }
            
            self.totalReviewList?.reviews[sender.tag].isLike = true
            
          case .failure:
            break
        }
      }
    }
    
  }
  
  @IBAction func didChangeSegementIndex(_ sender: UISegmentedControl) {
    
    guard let sortingOrder = SortingOrder(rawValue: sender.selectedSegmentIndex) else { return }
    
    guard totalReviewList != nil, let reviews = sortedReviewList(by: sortingOrder)  else { return }
    
    totalReviewList!.reviews = reviews
  }
  
  func trimStringDate(with: String) -> String {
    
    return with.components(separatedBy: "T")[0].components(separatedBy: "-").joined(separator: ".")
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 216
  }
  
  func sortedReviewList(by sortingOrder: SortingOrder) -> [PlaceReview]? {
    
    guard totalReviewList != nil else { return nil }
    
    switch sortingOrder {
      
      case .latest:
        
        return totalReviewList?.reviews.sorted(by: { lhs, rhs in
          
          guard let lhsDate = dateFormatter.date(from: lhs.createdAt), let rhsDate = dateFormatter.date(from: rhs.createdAt) else { return  true }
          
          return lhsDate > rhsDate
        })
        
      case .recommended:
        
        return totalReviewList?.reviews.sorted(by: { lhs, rhs in
          
          lhs.numOfLikes > rhs.numOfLikes
        })
        
      case .highRated:
        return totalReviewList?.reviews.sorted(by: { lhs, rhs in
          
         lhs.point > rhs.point
        })
        
      case .lowRated:
        return totalReviewList?.reviews.sorted(by: { lhs, rhs in
          
          lhs.point < rhs.point
        })
    }
  }
  
  /**
  메일로 신고하기 기능
   - Author: 박우찬
   */
  
  @IBAction func didTapReportButton(_ sender: UIButton) {
    
    let base = "mailto:zolle@kakao.com"
    
    guard let review = totalReviewList?.reviews[sender.tag] else {
      
      let alertController = UIAlertController(title: "리뷰 정보 불러오기 실패", message: "조금 후에 다시 시도해주세요", preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "알겠어요", style: .default, handler: nil)
      
      alertController.addAction(okAction)
      
      self.present(alertController, animated: true, completion: nil)
      
      return
    }
    
    guard let userNick = review.userNick.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
    
    let subject = "?subject=report:\(userNick)_\(review.id)"
    
    guard let bodyString = "불편하셨던 내용을 입력해주세요".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }

    let body = "&body=\(bodyString)"
    
    if let url = URL(string: base + subject + body) {
      
      UIApplication.shared.open(url, options: [:], completionHandler: { _ in
        
        let alertController = UIAlertController(title: "신고하기", message: "부적절한 리뷰를 신고해주세요.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "알겠어요", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
      })
    }
  }
  
}

extension AllReviewsTableViewController {
  
  enum SortingOrder: Int {
    case latest
    case recommended
    case highRated
    case lowRated
  }
}

