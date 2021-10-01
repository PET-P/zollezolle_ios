//
//  CategoryCell.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/30.
//

import UIKit

class CategoryCell: UICollectionViewCell {
  
  static let nibName = "CategoryCell"
  static let identifier = "CategoryCell"
  
  override func awakeFromNib() {
      super.awakeFromNib()
  }
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.font = .robotoBold(size: 14)
      titleLabel.textColor = .gray02
    }
  }
  
  override var isSelected: Bool {
    didSet {
      titleLabel.font = isSelected ? UIFont.robotoBold(size: 14) : UIFont.robotoMedium(size: 14)
    }
  }
}
