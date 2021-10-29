//
//  AllReviewsTableViewCell.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/29.
//

import UIKit

final class AllReviewsTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var nickNameLabel: UILabel!
  
  @IBOutlet weak var photoImageView: UIImageView!
  
  @IBOutlet private weak var ratingLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  var nickName: String = "" {
    didSet {
      nickNameLabel.text = nickName
    }
  }
  
  var ratingPoint = 0 {
    didSet {
      ratingLabel.text = "평점 : \(ratingPoint)"
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
  
  static var identifier: String {
    return String(describing: AllReviewsTableViewCell.self)
  }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
