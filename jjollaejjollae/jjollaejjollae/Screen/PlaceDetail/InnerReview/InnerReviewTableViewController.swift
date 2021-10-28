//
//  InnerReviewTableViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/28.
//

import UIKit

protocol ReviewListDataType {
  
  var value: [Review] { get set }
  
  var numOfReviews: Int { get }
  
  var isEmpty: Bool { get }
}

extension ReviewListDataType {
  
  var numOfReviews: Int {
    value.count
  }
  
  var isEmpty: Bool {
    return value.isEmpty
  }
}

class InnerReviewTableViewController: UITableViewController {
  
  var reviewList: ReviewListDataType?

  @IBOutlet weak var numOfReviewsLabel: UILabel! {
    didSet {
      
      let numbOfReviews = reviewList?.numOfReviews ?? 0
      
      numOfReviewsLabel.text = "총 \(numbOfReviews)개의 후기"
    }
  }
  
  @IBOutlet weak var createReviewButton: UIButton!
  
  @IBOutlet weak var showAllReviewsButton: UIButton! {
    didSet {
      guard let reviewList = reviewList else {
        
        showAllReviewsButton.isEnabled = false
        return
      }
      
      if reviewList.value.isEmpty {
        
        showAllReviewsButton.isEnabled = false
      } else {
        
        showAllReviewsButton.setTitle("후기 \(reviewList.numOfReviews)개 모두 보기", for: .normal)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 114
  }
  
  // MARK: - IBAction

  @IBAction func didTapCreateReviewButton(_ sender: UIButton) {
    
    print(#function)
  }
  
  @IBAction func didTapShowAllReviewsButton(_ sender: UIButton) {
    
    print(#function)
  }
  
  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
    
    guard let reviewList = reviewList else { return 0 }
    
    return reviewList.numOfReviews > 3 ? 3 : reviewList.numOfReviews
  }
  
  // MARK: - Table view delegate
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    /**
     리뷰 0개일때도 대응해야함
     */
    if let review = reviewList?.value[indexPath.row] {
      
      guard let innerReviewCell = tableView.dequeueReusableCell(withIdentifier: InnerReviewTableViewCell.identifier, for: indexPath) as? InnerReviewTableViewCell else { return UITableViewCell() }
      
      innerReviewCell.nickNameLabel.text = review.nickname
      
      innerReviewCell.ratingLabel.text = "\(review.point)"
      
      innerReviewCell.descriptionLabel.text = review.text
      
      
      return innerReviewCell

    }
    
    return UITableViewCell()
  }
}
