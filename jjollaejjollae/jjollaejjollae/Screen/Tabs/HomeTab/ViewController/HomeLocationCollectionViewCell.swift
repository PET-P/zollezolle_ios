//
//  HomeLocationCollectionViewCell.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/06.
//

import UIKit

class HomeLocationCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  var image: UIImage? {
    get {
      imageView.image
    }
    set {
      imageView.image = newValue
    }
  }
  
  var title: String? {
    get {
      titleLabel.text
    }
    set {
      titleLabel.text = newValue
    }
  }
  
  private let figmaCornerRadius: CGFloat = 8
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    self.layer.cornerRadius = figmaCornerRadius
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
    
}
