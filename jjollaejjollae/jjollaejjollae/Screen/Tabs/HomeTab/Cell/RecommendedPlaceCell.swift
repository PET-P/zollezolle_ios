//
//  RecommendedPlaceCell.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/18.
//

import UIKit

class RecommendedPlaceCell: UICollectionViewCell, Identifiable {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var label: UILabel!
  
  override func awakeFromNib() {
    imageView.layer.cornerRadius = 8
    label.font = UIFont.robotoBold(size: 14)
  }
}


