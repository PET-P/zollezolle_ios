//
//  InfoTableViewCell.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/02.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.font = .robotoMedium(size: 18)
      titleLabel.textColor = .gray01
    }
  }
  
  @IBOutlet weak var subtitle: UILabel! {
    didSet {
      subtitle.font = .robotoMedium(size: 12)
      subtitle.textColor = .gray03
    }
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



