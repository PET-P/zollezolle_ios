//
//  HomeTipCollectionViewCell.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/08.
//

import UIKit

class HomeTipCollectionViewCell: UICollectionViewCell{
  
  static let identifier = String(describing: HomeTipCollectionViewCell.self)
  
  @IBOutlet weak var titleLabel: UILabel!

  @IBOutlet weak var emojiLabel: UILabel!
  
  var titleText: String? {
    get {
      titleLabel.text
    }
    set {
      titleLabel.text = newValue
    }
  }
  
  private let figmaCornerRadius: CGFloat = 8
  
  override func awakeFromNib() {
    
    setUpLayerOptions()
    setUpLayoutContraints()
  }
  
  private func setUpLayerOptions() {
  
    self.layer.masksToBounds = false
    
    self.layer.cornerRadius = figmaCornerRadius
    
    self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
    
    self.layer.shadowColor = UIColor.lightGray.cgColor
    
    self.layer.shadowOpacity = 0.5
    
    self.layer.shadowRadius = figmaCornerRadius
    
    // contentView
    self.contentView.layer.cornerRadius = figmaCornerRadius
    
    self.contentView.layer.masksToBounds = true
    
    
    // FIXME: View 계층 1개 줄이기
    self.contentView.mainView?.layer.cornerRadius = 8
  }
  
  private func setUpLayoutContraints() {
    
    self.heightAnchor.constraint(equalToConstant: 120).isActive = true
    self.widthAnchor.constraint(equalToConstant: 116).isActive = true
  }

}

extension HomeTipCollectionViewCell {
  
  struct HomeTipData {
    
    var title: String
    var urlString: String
    var emoji: String
  }
  
  static var tipDataList: [HomeTipData]  =
    [
     HomeTipData(title: "비행기가\n처음인\n친구들을\n위해", urlString: "https://zolle.tistory.com/2", emoji: "✈️"),
      HomeTipData(title: "반려동물\n동반\n체크리스트", urlString: "https://zolle.tistory.com/3", emoji: "✅"),
      HomeTipData(title: "여행 중\n응급상황\n대처 방법", urlString: "https://zolle.tistory.com/4", emoji: "🚨")
    ]
}
