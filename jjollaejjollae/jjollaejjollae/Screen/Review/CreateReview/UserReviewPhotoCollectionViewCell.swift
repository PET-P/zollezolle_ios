//
//  UserReviewPhotoCollectionViewCell.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/29.
//

import UIKit

final class UserReviewPhotoCollectionViewCell: UICollectionViewCell {
  
  static let identifier = String(describing: UserReviewPhotoCollectionViewCell.self)
  
  @IBOutlet weak var deleteButton: UIButton!
  
  @IBOutlet private weak var mainImageView: UIImageView!
  
  var mainImage: UIImage? {
    didSet {
      mainImageView.image = mainImage
    }
  }
  
  override func awakeFromNib() {
    
//    self.layer.cornerRadius = 5
//    self.layer.masksToBounds = true
  }
}
