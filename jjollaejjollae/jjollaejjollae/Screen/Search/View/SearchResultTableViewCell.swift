//
//  SearchResultTableViewCell.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/16.
//

import UIKit

protocol SearchResultCellDelegate {
  func didTapHeart(for placeId: Int, like: Bool)
}

class SearchResultTableViewCell: UITableViewCell {
  //MARK: - IBOUTLET
  
  @IBOutlet weak var cellImageView: UIImageView! {
    didSet {
      cellImageView.translatesAutoresizingMaskIntoConstraints = false
      cellImageView.setRounded(radius: 8)
      cellImageView.isUserInteractionEnabled = true
    }
  }
  
  @IBOutlet weak var addressLabel: UILabel! {
    didSet {
      addressLabel.translatesAutoresizingMaskIntoConstraints = false
      addressLabel.text = "제주 애월읍"
      addressLabel.font = .robotoMedium(size: 12)
      addressLabel.textColor = .회
    }
  }
  
  @IBOutlet weak var locationNameLabel: UILabel! {
    didSet {
      locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
      locationNameLabel.font = .robotoBold(size: 16)
      locationNameLabel.textColor = .쫄래블랙
    }
  }
  @IBOutlet weak var locationTypeLabel: UILabel! {
    didSet {
      locationTypeLabel.translatesAutoresizingMaskIntoConstraints = false
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
  @IBOutlet weak var heartButton: UIButton!
  @IBOutlet weak var priceLabel: UILabel! {
    didSet {
      priceLabel.text = "85,000원"
      priceLabel.textColor = .쫄래블랙
      priceLabel.font = .robotoBold(size: 16)
    }
  }
  
  @IBOutlet weak var DaysLabel: UILabel! {
    didSet {
      DaysLabel.text = "1박 요금"
      DaysLabel.textColor = .회
      DaysLabel.font = .robotoMedium(size: 10)
    }
  }
  
  var isWish: Bool? {
    didSet {
      if isWish == true {
        heartButton.setImage(UIImage(named: "pinkLike"), for: .normal)
      } else {
        heartButton.setImage(UIImage(named: "grayLike"), for: .normal)
      }
    }
  }
  
  override func prepareForReuse() {
    DaysLabel.isHidden = true
    priceLabel.isHidden = true
    contentStackView.insertArrangedSubview(addressLabel, at: 0)
    addressLabel.isHidden = true
  }
  
  var delegate : SearchResultCellDelegate?
  var index : Int? //얘를 key(디비에 장소의 id)
  var placeId: Int = -1
  
  @IBAction func didTapHeartButton(_ sender: UIButton) {
    if sender.isSelected {
      isWish = true
      delegate?.didTapHeart(for: placeId, like: true)
    } else {
      isWish = false
      delegate?.didTapHeart(for: placeId, like: false)
    }
    sender.isSelected = !sender.isSelected
  }
  
  @IBOutlet weak var contentStackView: UIStackView!
  @IBOutlet weak var LocationStackView: UIStackView!
  @IBOutlet weak var starStackView: UIStackView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}


