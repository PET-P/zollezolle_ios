//
//  WishlistCollectionViewCell.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/09/21.
//

import UIKit

class WishlistCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var wishListTitle: UILabel! {
    didSet {
      wishListTitle.textColor = .gray01
      wishListTitle.font = .robotoBold(size: 18)
    }
  }
  @IBOutlet weak var wishListLocation: UILabel!{
    didSet {
      wishListLocation.textColor = .gray03
      wishListLocation.font = .robotoMedium(size: 14)
    }
  }
  @IBOutlet weak var wishListDate: UILabel! {
    didSet {
      wishListDate.textColor = .gray03
      wishListDate.font = .robotoMedium(size: 14)
    }
  }
  
  override func awakeFromNib() { }
  
  internal func fillContent(with data: FolderData) {
    wishListTitle.text = data.name
    
    if let startDate = data.startDate, let endDate = data.endDate {
      let startDate = startDate.components(separatedBy: "T")[0].components(separatedBy: "-")[1...2].joined(separator: ".")
      let endDate = endDate.components(separatedBy: "T")[0].components(separatedBy: "-")[1...2].joined(separator: ".")
      wishListDate.text = "\(startDate)-\(startDate)"
    } else {
      wishListDate.text = " "
    }
    
    if data.regions.count > 2 {
      wishListLocation.text = "\(data.regions[0])/\(data.regions[1]) 외 \(data.regions.count - 2)"
    } else if data.regions.count  > 1 {
      wishListLocation.text = "\(data.regions[0])/\(data.regions[1])"}
    else if data.regions.count  > 0 {
      wishListLocation.text = "\(data.regions[0])"
    } else {
      wishListLocation.text = " "
    }
  }
}
