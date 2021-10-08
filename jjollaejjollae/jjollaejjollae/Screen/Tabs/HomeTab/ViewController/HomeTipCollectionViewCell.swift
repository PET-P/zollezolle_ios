//
//  HomeTipCollectionViewCell.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/08.
//

import UIKit

class HomeTipCollectionViewCell: UICollectionViewCell{

  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var imageView: UIImageView!
  
  var titleText: String? {
    get {
      titleLabel.text
    }
    set {
      titleLabel.text = newValue
    }
  }
  
  var image: UIImage? {
    get {
      imageView.image
    }
    
    set {
      imageView.image = image
    }
  }
  
  private let figmaCornerRadius: CGFloat = 8
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.layer.cornerRadius = figmaCornerRadius
    
    // Shdow Options
    self.layer.masksToBounds = false
    self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
    self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    self.layer.shadowOpacity = 1
    self.layer.shadowRadius = 5
  }

}
