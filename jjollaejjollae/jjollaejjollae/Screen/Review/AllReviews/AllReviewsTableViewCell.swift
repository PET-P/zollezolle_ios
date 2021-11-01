//
//  AllReviewsTableViewCell.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/29.
//

import UIKit

final class AllReviewsTableViewCell: UITableViewCell {
  
  static let  identifier: String = String(describing: AllReviewsTableViewCell.self)
  
  @IBOutlet private weak var nickNameLabel: UILabel!
  
  @IBOutlet weak var photoImageView: UIImageView! {
    didSet {
      photoImageView.layer.masksToBounds = true
      photoImageView.layer.cornerRadius = 8
    }
  }
  
  @IBOutlet weak var ratingStarImageView: UIImageView!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  var nickName: String = "" {
    didSet {
      nickNameLabel.text = nickName
    }
  }
  
  var descriptionText: String = "등록된 리뷰가 없습니다" {
    didSet {
      descriptionLabel.text = descriptionText
    }
  }
  
  var dateText: String = "\(Date())" {
    didSet{
      dateLabel.text = dateText
    }
  }
  
  @IBOutlet weak var likeButton: UIButton! {
    didSet {
      
      likeButton.layer.cornerRadius = likeButton.frame.height / 2
      likeButton.layer.borderWidth = 1
    }
  }
  
  var isLikeButtonSelected: Bool = false {
    didSet {
      likeButton.layer.borderColor = isLikeButtonSelected ? UIColor.themeGreen.cgColor : UIColor.gray06.cgColor
      
      if isLikeButtonSelected {
        numOfLikes += 1
      }
    }
  }
  
  var numOfLikes: Int = 0 {
    didSet {
      likeButton.setTitle("도움돼요 \(numOfLikes)", for: .normal)
    }
  }
  
  var ratingPoint: Int = 5 {
    
    didSet {
      ratingStarImageView.image = UIImage(named: "star\(ratingPoint)") ?? nil
    }
    
  }
  
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }
}
