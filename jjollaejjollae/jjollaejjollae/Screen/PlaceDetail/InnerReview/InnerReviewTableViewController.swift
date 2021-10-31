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
  
//  var placeDetailTableVC: PlaceDetailTableViewController? {
//    guard let vc = parent as? PlaceDetailTableViewController else { return nil }
//
//    return vc
//  }
  
//  var mainImage: UIImage?
  
  var placeInfo: PlaceInfo?
  
//  var reviewCount: Int?
  
//  var reviewList: ReviewListDataType?

  @IBOutlet weak var numOfReviewsLabel: UILabel! {
    didSet {
      
      let numOfReviews = placeInfo?.reviewCount ?? 0
      
      numOfReviewsLabel.text = "총 \(numOfReviews)개의 후기"
    }
  }
  
  @IBOutlet weak var createReviewButton: UIButton!
  
  @IBOutlet weak var showAllReviewsButton: UIButton! {
    didSet {
      
      guard let placeInfo = placeInfo, !placeInfo.reviewList.value.isEmpty else {
        
        showAllReviewsButton.isEnabled = false
        chevronRightImageVIew.isHidden = true
        
        return
      }

      showAllReviewsButton.setTitle("\(placeInfo.reviewCount)개의 후기 모두 보기 ", for: .normal)
    }
  }
  
  @IBOutlet weak var chevronRightImageVIew: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 114
    
//    parent as? Detail
  }
  
  // MARK: - IBAction
  
  /**
  [후기 작성하기] 버튼 탭 시 호출되는 메서드
   - 사진데이터를 전달한다
   - 장소 이름을 전달한다
  */

  @IBAction func didTapCreateReviewButton(_ sender: UIButton) {
    
    guard let vc = CreateReviewViewController.loadFromStoryboard() as? CreateReviewViewController else { return }
    
    vc.placeInfo = placeInfo
    
    vc.placeTitle = placeInfo?.title
    
    vc.placeId = placeInfo?.id
    
    vc.category = placeInfo?.category
    
    vc.modalPresentationStyle = .fullScreen
    
    self.present(vc, animated: true, completion: nil)
  }
  
  @IBAction func didTapShowAllReviewsButton(_ sender: UIButton) {
    
    guard let vc = AllReviewsTableViewController.loadFromStoryboard() as? AllReviewsTableViewController else { return }
    
    self.parent?.navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
    
    guard let reviewList = placeInfo?.reviewList else { return 0 }
    
    return reviewList.numOfReviews > 2 ? 2 : reviewList.numOfReviews
  }
  
  // MARK: - Table view delegate
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    /**
     리뷰 0개일때 대응
     */
    if let review = placeInfo?.reviewList.value[indexPath.row] {
      
      guard let innerReviewCell = tableView.dequeueReusableCell(withIdentifier: InnerReviewTableViewCell.identifier, for: indexPath) as? InnerReviewTableViewCell else { return UITableViewCell() }
      
      innerReviewCell.nickNameLabel.text = review.nickname
      
      innerReviewCell.ratingLabel.text = "\(review.point)"
      
      innerReviewCell.descriptionLabel.text = review.text
      
      innerReviewCell.dateLabel.text = "\(review.createdAt.stringFromServerToDate())"
      
      
      return innerReviewCell

    }
    
    return UITableViewCell()
  }
}
