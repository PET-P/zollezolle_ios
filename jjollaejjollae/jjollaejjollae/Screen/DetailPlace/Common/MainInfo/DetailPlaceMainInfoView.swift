//
//  DetailMainPlaceInfoView.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/23.
//

import UIKit

final class DetailPlaceMainInfoView: UIView {

  // MARK: - IBOutlets
  @IBOutlet weak var nameLabel: UILabel!            // 장소 레이블
  
  // TODO: 최대 너비 제약 추가 해야한다.
  @IBOutlet weak var locationLabel: UILabel!        // 주소 레이블
  @IBOutlet weak var viewMapButton: UIButton!       // 지도보기 버튼
  @IBOutlet weak var averageRatingLabel: UILabel!   // 평균 병점 & 리뷰 개수 레이블
  
  @IBOutlet weak var customInfoLabel: UILabel!
  
  @IBOutlet weak var expandButton: UIButton!        // 시설 안내 더보기 버튼
  
  // MARK: - Properties
  private let viewMapButtonTitleLabelText: String = "지도보기"
  
  private var ratingValue: String?                  // 평균 별점
  private var numOfReviews: Int?                    // 리뷰 개수
//  var location: String {get}              // 도로명 주소
//  var averageRating: Float { get }        // 평균 평점 (단위: 별)
//  var reviews: [ReviewType]? { get }      // 리뷰
//  var customInfo: String? { get }         // 장소 관련자가 직접 입력하는 장소 소개
//  var basicInfo: BasicInfoType { get }
  
  private var heightConstraint: NSLayoutConstraint?
  
  
  // MARK: - Costants
  
  
  
  // MARK: - Life Cycle
  override func awakeFromNib() {
    
    setUpLayoutConstraints()
    
    setUpNameLabel()
    
    setUpLocationLabel()
    
    setUpViewMapButton()
    
    setUpLocationLabelText(with: "제주시 애월읍 신엄안 3길 제주시 애월읍 신엄안 3길")
    
    setUpAverageRatingLabelText(ratingValue: 4.9, numOfReviews: 51)
    
    setUpExpandButton()
  }
  
  // MARK: - Public Customs
  
  public func setUpNameLabelText(with name: String?) {
    self.nameLabel.text = name ?? "로딩에 실패하였습니다."
  }
  
  public func setUpLocationLabelText(with location: String?) {
    self.locationLabel.text = location ?? "로딩에 실패하였습니다."
  }
  
  public func setUpAverageRatingLabelText(ratingValue: Float, numOfReviews: Int) {
    
    let ratingValue = String(ratingValue)
    let numOfReviews = "(\(String(numOfReviews)))"
    
    let foregroundColor = UIColor.회
    let kern = NSNumber(-1.5)
    
    let averageRatingText = NSMutableAttributedString()
    
    var attributes: [NSAttributedString.Key: Any] = [.font: UIFont.robotoBold(size: 14),
                      .foregroundColor: foregroundColor,
                      .kern: kern]
    
    let ratingValueText = NSAttributedString(string: ratingValue, attributes: attributes)
    
    averageRatingText.append(ratingValueText)
    
    attributes = [.font: UIFont.robotoRegular(size: 14),
                  .foregroundColor: foregroundColor,
                  .kern: kern]
    
    let whiteSpaceText = NSAttributedString(string: " ", attributes: attributes)
    
    averageRatingText.append(whiteSpaceText)
    
    let numOfReviewsText = NSAttributedString(string: numOfReviews, attributes: attributes)
    
    averageRatingText.append(numOfReviewsText)
    
    averageRatingLabel.attributedText = averageRatingText
  }
  
  
  // MARK: - Private Customs
  
  private func setUpLayoutConstraints() {
    
    heightConstraint = self.heightAnchor.constraint(equalToConstant: 390)
    heightConstraint?.isActive = true
    
    directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16)
  }
  
  private func setUpNameLabel() {
    
    nameLabel.font = UIFont.robotoBold(size: 24)
  }
  
  private func setUpLocationLabel() {
    
    locationLabel.font = UIFont.robotoMedium(size: 14)
  }

  private func setUpViewMapButton() {
    
    viewMapButton.semanticContentAttribute = .forceRightToLeft
    
    viewMapButton.tintColor = UIColor.쫄래그린
    
    viewMapButton.setTitle(viewMapButtonTitleLabelText, for: .normal)
    viewMapButton.setTitleColor(UIColor.쫄래그린, for: .normal)
    viewMapButton.titleLabel?.font = UIFont.robotoBold(size: 14)
  }
  
  private func setUpCustomInfoLabel() {
    
    customInfoLabel.numberOfLines = 3
    customInfoLabel.setLineSpacing(spacing: 0.7)
  }
  
  private func setUpExpandButton() {
    
    expandButton.tintColor = .black
    
    expandButton.setTitle("더보기", for: .normal)
    expandButton.titleLabel?.font = UIFont.robotoBold(size: 14)
    expandButton.setTitle("접어두기", for: .selected)
  }
  
  // MARK: - IBActions
  
  @IBAction func didTapViewMapButton(_ sender: UIButton) {
      
    // MARK: - Noti 방출 해야할 듯
    print(#function)
  }

  @IBAction func didTapExpandButton(_ sender: UIButton) {
    
    sender.isSelected.toggle()
    
    if customInfoLabel.numberOfLines == 3 {
      
      customInfoLabel.numberOfLines = 0
      
      heightConstraint?.constant = (heightConstraint?.constant)! + CGFloat(customInfoLabel.frame.height)
      
    } else {
      
      customInfoLabel.numberOfLines = 3
      heightConstraint?.constant = 400
    }
  }
  
  
  
}

extension DetailPlaceMainInfoView: NibInstantiatable { }

extension DetailPlaceMainInfoView {
}
