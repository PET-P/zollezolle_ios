//
//  TableViewCell.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import UIKit

class ReviewTableCell: UITableViewCell {
  
  static let nibName = "ReviewTableCell"
  internal var defaultImageData = UIImage(named: "IMG_4930")!
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.font = .robotoBold(size: 18)
      titleLabel.textColor = .gray01
    }
  }
  @IBOutlet weak var starImageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!{
    didSet {
      dateLabel.font = .robotoRegular(size: 12)
      dateLabel.textColor = .gray03
    }
  }
  @IBOutlet weak var deleteButton: UIButton! {
    didSet {
      deleteButton.backgroundColor = .gray06
      deleteButton.setTitleColor(.gray03, for: .normal)
      deleteButton.setRounded(radius: nil)
      deleteButton.titleLabel?.font = .robotoRegular(size: 13)
    }
  }
  @IBOutlet weak var reviewLabel: UILabel! {
    didSet {
      reviewLabel.textColor = .gray01
      reviewLabel.font = .robotoRegular(size: 16)
    }
  }
  @IBOutlet weak var thumbLabel: helpLabel! {
    didSet {
      thumbLabel.helpNumber = 99
    }
  }
  @IBOutlet weak var hundredLabel: helpLabel! {
    didSet {
      hundredLabel.helpNumber = 4
      hundredLabel.helpImage = "100Btn"
    }
  }
  @IBOutlet weak var heartLabel: helpLabel! {
    didSet {
      heartLabel.helpNumber = 7
      heartLabel.helpImage = "heartBtn"
    }
  }
  @IBOutlet weak var contentStackView: UIStackView!
  
  @IBOutlet weak var tagStackView: UIStackView!
  @IBOutlet var tags: [UIButton]! {
    didSet {
      tags.forEach { (button) in
        button.isUserInteractionEnabled = false
        button.setRounded(radius: nil)
        button.backgroundColor = .gray07
        button.setTitleColor(.gray02, for: .normal)
      }
    }
  }
  @IBOutlet weak var reviewImageView: UIImageView!{
    didSet {
      setupImage(imageView: reviewImageView)
    }
  }
  
  
  var reviewIndex: Int = 0
  var reviewId: String = ""
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  private func setupImage(imageView: UIImageView) {
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 10
    imageView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func didTapDeleteButton(_ sender: UIButton!) {
    NotificationCenter.default.post(name: NSNotification.Name("deleteReviewNotification"), object: nil, userInfo: ["index": self.reviewIndex, "reviewId": self.reviewId])
  }
}
