//
//  SearchResultTableViewCell.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/16.
//

import UIKit

protocol SearchResultCellDelegate: AnyObject {
  func didTapHeart(for placeId: String, like: Bool)
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
      addressLabel.textColor = .gray03
    }
  }
  
  @IBOutlet weak var locationNameLabel: UILabel! {
    didSet {
      locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
      locationNameLabel.font = .robotoBold(size: 16)
      locationNameLabel.textColor = .gray01
    }
  }
  @IBOutlet weak var locationTypeLabel: UILabel! {
    didSet {
      locationTypeLabel.translatesAutoresizingMaskIntoConstraints = false
      locationTypeLabel.font = .robotoMedium(size: 12)
      locationTypeLabel.textColor = .gray03
    }
  }
  @IBOutlet weak var starPointLabel: UILabel! {
    didSet {
      starPointLabel.font = .robotoBold(size: 12)
      starPointLabel.textColor = .gray03
    }
  }
  @IBOutlet weak var numberOfReviewsLabel: UILabel! {
    didSet {
      numberOfReviewsLabel.font = .robotoRegular(size: 10)
      numberOfReviewsLabel.textColor = .gray03
    }
  }
  @IBOutlet weak var heartButton: UIButton! {
    didSet {
      heartButton.setImage(UIImage(named: "pinkLike"), for: .selected)
      heartButton.setImage(UIImage(named: "grayLike"), for: .normal)
    }
  }
  @IBOutlet weak var priceLabel: UILabel! {
    didSet {
      priceLabel.alpha = 0
    }
  }
  
  @IBOutlet weak var DaysLabel: UILabel! {
    didSet {
      DaysLabel.alpha = 0
    }
  }
  
  var isWish: Bool? {
    didSet {
      if isWish == true {
//        heartButton.setImage(UIImage(named: "pinkLike"), for: .normal)
        heartButton.isSelected = true
      } else {
//        heartButton.setImage(UIImage(named: "grayLike"), for: .normal)
        heartButton.isSelected = false
      }
    }
  }
  
  // 설명
  // 처음에 버튼을 누름 ttff
  // 돌리면 재사용이 일어날수 있는데
  // 결국엔 cellforrowat에 들어갔을때 이 셀의 true false를 알아야한다.
  // 그래서 결국에는 셀이 true false를 가지고있고
  // 셀의 상태를 계속봐서 버튼색을 초기화해주는 친구가 필요할 것 같다
  
  override func prepareForReuse() {
//    cellImageView.image = UIImage.colorImage(color: CGColor.init(gray: 0.5, alpha: 0.5), size: cellImageView.bounds.size)
//    locationNameLabel.text = ""
//    addressLabel.text = " "
//    DaysLabel.isHidden = true
//    priceLabel.isHidden = true
//    contentStackView.insertArrangedSubview(addressLabel, at: 0)
  }
  
  weak var delegate : SearchResultCellDelegate?
  var index : Int? //얘를 key(디비에 장소의 id)
  var placeId: String = "1"
  
  @IBAction func didTapHeartButton(_ sender: UIButton) { //상태를 바꿔준다. 셀이 아닌 버튼만 바꿔준다면 재사용의 문제가 생긴다.
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


