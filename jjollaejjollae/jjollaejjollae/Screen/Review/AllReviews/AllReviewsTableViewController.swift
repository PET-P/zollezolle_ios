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
      
      guard let totalReviewList = totalReviewList else { return }
      
      numOfTotalReviewLabel.text = "총 \(totalReviewList.numOfTotalReview)개의 후기"
      
      ratingPointLabel.text = String(format: "%.1f", totalReviewList.avgPoint)
      
      tableView.reloadData()
      
    }
  }
  
  @IBOutlet weak var numOfTotalReviewLabel: UILabel!
  
  @IBOutlet weak var ratingPointLabel: UILabel!
  
  private let dateFormatter: DateFormatter = {
    
    let formatter = DateFormatter()
    formatter.dateFormat = .some("yyyy-MM-dd")
    return formatter
    
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.backBarButtonItem?.tintColor = .black
    
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
    
    sortReviewList(by: sortingOrder)
  }
  
  func trimStringDate(with: String) -> String {
    
    return with.components(separatedBy: "T")[0].components(separatedBy: "-").joined(separator: ".")
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 216
  }
  
  func sortReviewList(by sortingOder: SortingOrder) {
    
    switch sortingOder {
      
      case .latest:
        
        totalReviewList?.reviews.sort(by: { lhs, rhs in
          
          guard let lhsDate = dateFormatter.date(from: lhs.createdAt), let rhsDate = dateFormatter.date(from: rhs.createdAt) else { return  true }
          
          return lhsDate > rhsDate
        })
        
      case .recommended:
        
        totalReviewList?.reviews.sort(by: { lhs, rhs in
          
          return lhs.numOfLikes > rhs.numOfLikes
        })
        
      case .highRated:
        totalReviewList?.reviews.sort(by: { lhs, rhs in
          
          return lhs.point > rhs.point
        })
        
      case .lowRated:
        totalReviewList?.reviews.sort(by: { lhs, rhs in
          
          return lhs.point < rhs.point
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

