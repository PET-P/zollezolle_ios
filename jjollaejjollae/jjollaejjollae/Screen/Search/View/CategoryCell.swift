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
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.font = .robotoBold(size: 14)
      titleLabel.textColor = .gray02
    }
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
