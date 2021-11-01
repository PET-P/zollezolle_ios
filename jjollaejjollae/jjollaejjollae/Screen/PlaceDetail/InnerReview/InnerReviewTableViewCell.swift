//
//  InnerReviewTableViewCell.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/28.
//

import UIKit

class InnerReviewTableViewCell: UITableViewCell {
  
  static var identifier: String {
    return String(describing: InnerReviewTableViewCell.self)
  }
  
  @IBOutlet weak var thumbnailImageView: UIImageView! {
    didSet {
      thumbnailImageView.layer.masksToBounds = true
      thumbnailImageView.layer.cornerRadius = 8
    }
  }
  
  @IBOutlet weak var nickNameLabel: UILabel!
  
  @IBOutlet weak var ratingStarImageView: UIImageView!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  var ratingPoint: Int = 5 {
    didSet {
      ratingStarImageView.image = UIImage(named: "star\(ratingPoint)") ?? nil
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
}
