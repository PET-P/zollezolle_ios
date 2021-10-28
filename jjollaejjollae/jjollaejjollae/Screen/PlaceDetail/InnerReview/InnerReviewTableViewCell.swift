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
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  
  @IBOutlet weak var nickNameLabel: UILabel!
  
  @IBOutlet weak var ratingLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
}
