//
//  SearchTableViewCell.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/15.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
  
  @IBOutlet weak var recommendLabel: UILabel! {
    didSet {
      recommendLabel.font = .robotoRegular(size: 16)
      recommendLabel.textColor = .gray01
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
