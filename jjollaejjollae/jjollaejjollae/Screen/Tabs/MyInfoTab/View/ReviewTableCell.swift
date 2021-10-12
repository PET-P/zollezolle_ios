//
//  TableViewCell.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import UIKit

class ReviewTableCell: UITableViewCell {
  
  static let nibName = "ReviewTableCell"
  private var defaultImageData = UIImage(named: "IMG_4930")?.jpegData(compressionQuality: 0.5)
  
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
  
  let reviewImageView: ReviewImageView = {
    let reviewView = ReviewImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 343), numberOfImage: 3)
    reviewView.translatesAutoresizingMaskIntoConstraints = false
    return reviewView
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentStackView.insertArrangedSubview(reviewImageView, at: 2)
    reviewImageView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor).isActive = true
    reviewImageView.heightAnchor.constraint(equalToConstant: 343).isActive = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
