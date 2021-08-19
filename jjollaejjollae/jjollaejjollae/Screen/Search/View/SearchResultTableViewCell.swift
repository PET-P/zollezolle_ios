//
//  SearchResultTableViewCell.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/16.
//

import UIKit

protocol SearchResultCellDelegate {
  func didTapHeart(for index: Int, like: Bool)
}

class SearchResultTableViewCell: UITableViewCell {
  //MARK: - IBOUTLET
  @IBOutlet weak var cellImageView: UIImageView! {
    didSet {
      cellImageView.setRounded(radius: 8)
      cellImageView.isUserInteractionEnabled = true
    }
  }
  
  @IBOutlet weak var addressLabel: UILabel! {
    didSet {
      addressLabel.isHidden = true
      addressLabel.font = .robotoMedium(size: 12)
      addressLabel.textColor = .회
    }
  }
  
  @IBOutlet weak var locationNameLabel: UILabel! {
    didSet {
      locationNameLabel.font = .robotoBold(size: 16)
      locationNameLabel.textColor = .쫄래블랙
    }
  }
  @IBOutlet weak var locationTypeLabel: UILabel! {
    didSet {
      locationTypeLabel.font = .robotoMedium(size: 12)
      locationTypeLabel.textColor = .회
    }
  }
  @IBOutlet weak var starPointLabel: UILabel! {
    didSet {
      starPointLabel.font = .robotoBold(size: 12)
      starPointLabel.textColor = .회
    }
  }
  @IBOutlet weak var numberOfReviewsLabel: UILabel! {
    didSet {
      numberOfReviewsLabel.font = .robotoRegular(size: 10)
      numberOfReviewsLabel.textColor = .회
    }
  }
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var priceLabel: UILabel! {
    didSet {
      priceLabel.isHidden = true
      priceLabel.textColor = .쫄래블랙
      priceLabel.font = .robotoBold(size: 16)
    }
  }
  
  @IBOutlet weak var DaysLabel: UILabel! {
    didSet {
      DaysLabel.isHidden = true
      DaysLabel.textColor = .회
      DaysLabel.font = .robotoMedium(size: 10)
    }
  }
  
  var isWish: Bool? {
    didSet {
      if isWish == true {
        likeButton.setImage(UIImage(named: "pinkLike"), for: .normal)
      } else {
        likeButton.setImage(UIImage(named: "grayLike"), for: .normal)
      }
    }
  }
  
  var delegate : SearchResultCellDelegate?
  var index : Int?
  
  @IBAction func didTapHeart(_ sender: UIButton) {
    guard let index = index else {return}
    if sender.isSelected {
      isWish = true
      delegate?.didTapHeart(for: index, like: true)
    } else {
      isWish = false
      delegate?.didTapHeart(for: index, like: false)
    }
    sender.isSelected = !sender.isSelected
  }

  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 42, right: 0)
    contentView.frame = contentView.frame.inset(by: padding)
  }
  
  
}


