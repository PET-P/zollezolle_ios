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
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    print(imageView)
    
    print(titleLabel)
    
  }
  
    
}
