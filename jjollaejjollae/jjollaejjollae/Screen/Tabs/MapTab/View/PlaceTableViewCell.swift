//
//  PlaceTableViewCell.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/31.
//

import UIKit

final class PlaceTableViewCell: UITableViewCell {
  
  static let identifier = String(describing: PlaceTableViewCell.self)

  @IBOutlet weak var mainImageView: UIImageView! {
    didSet {
      mainImageView.layer.masksToBounds = true
      mainImageView.layer.cornerRadius = 8
      mainImageView.backgroundColor = .themePaleGreen
    }
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var categoryLabel: UILabel!
  
  @IBOutlet weak var reviewPointLabel: UILabel!
  
  @IBOutlet weak var reviewCountLabel: UILabel!
  
  var placeTitle: String = "불러오기 실패" {
    didSet {
      titleLabel.text = placeTitle
    }
  }
  
  var category: String = "미분류" {
    didSet {
      categoryLabel.text = category
    }
  }
  
  var reviewPoint: Double = 0.0 {
    didSet {
      reviewPointLabel.text = "\(reviewPoint)"
    }
  }
  
  var reviewCount: Int = 0{
    didSet {
      reviewCountLabel.text = "(\(reviewCount))"
    }
  }
}
