//
//  PlaceDetailTableViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/27.
//

import UIKit
import Moya
import SwiftyJSON
import NMapsMap

class PlaceDetailTableViewController: UITableViewController, StoryboardInstantiable {
  
  /**
   이전 화면에서 전달? 아니면 직접 네트워크 통신으로 불러옴?
   */
  var placeInfo: PlaceInfo?
  
  /**
  메인 (TableView Header)
   */
  
  @IBOutlet weak var mainImageView: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var locationLabel: UILabel!  // 기본 정보에서 재사용
  
  @IBOutlet weak var ratingLabel: UILabel!
  
  /**
   시설 안내
   */
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var expandButton: UIButton!
  
  /**
   기본 정보
   */
  
  @IBOutlet weak var mapView: NMFMapView!
  
  @IBOutlet weak var phoneNumberLabel: UILabel!
  
  @IBOutlet weak var locationBasicLabel: UILabel!
  
  @IBOutlet weak var innerReviewCellHeightConstraint: NSLayoutConstraint!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    tableView.tableHeaderView?.heightAnchor.
    
    setUpTableViewHeader()
    
    adjustInnerReviewCellHeight()
  }
  
  func setUpTableViewHeader() {
    guard let placeInfo = placeInfo else { return }
    
    titleLabel.text = placeInfo.title
    let locationString = placeInfo.address.reduce("") { result, part in
      
      if result == "" {
        return result + part
      }
      
      return result + " " + part
    }
    
    locationLabel.text = locationString
    
    phoneNumberLabel.text = placeInfo.phone
    
    locationBasicLabel.text = locationString
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? InnerReviewTableViewController {
      
      vc.reviewList = ReviewCollection.mock
    }
  }
  
  @IBAction func didTapExpandButton(_ sender: UIButton) {
    
//    descriptionLabel.numberOfLines = descriptionLabel.numberOfLines == 5 ? 0 : 5
    
    switch descriptionLabel.numberOfLines {
      case 0 :
        descriptionLabel.numberOfLines = 5
        expandButton.setTitle("더 보기", for: .normal)
      case 5 :
        descriptionLabel.numberOfLines = 0
        expandButton.setTitle("접기", for: .normal)
      default :
        return
    }
  
    self.tableView.reloadData()
  }
  
  @IBAction func didTapBackButton(_ sender: Any){
    
    self.navigationController?.popViewController(animated: true)
  }
  /**
   리뷰 개수에 맞게 셀의 높이를 조정한다
   */
  
  private func adjustInnerReviewCellHeight() {
    
    guard let placeInfo = placeInfo else { return }
    
    let numOfReviews = placeInfo.reviewList.numOfReviews
    
    switch numOfReviews {
      case 0:
        innerReviewCellHeightConstraint.constant = 166

      case 1:
        innerReviewCellHeightConstraint.constant = 166 + 114
      case 2:
        innerReviewCellHeightConstraint.constant = 166 + (114 * 2)
      default:
        return
    }
    
  }
  
  
  
  
  
  
  
  

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplte implementation, return the number of rows
      return 3
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch indexPath.row {
      
      /**
       시설안내
       */
      case 0 :
        return UITableView.automaticDimension
        
      /**
       후기
       */
      case 1 :
        return UITableView.automaticDimension
        
      /**
       기본정보
       */
      case 2 :
        return 357
        
      default:
        return 0
    }
  }
}

