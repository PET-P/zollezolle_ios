//
//  DetailAccomodationsViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/17.
//

import UIKit

class DetailAccomodationsViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var imageContentView: UIView!
  
  @IBOutlet weak var imageContentHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var verticalStackView: UIStackView!
  
  // MARK: - Properties
  
  private var detailPlaceData: DetailPlaceType?
  
  private var navigationBar: UINavigationBar? {
    return self.navigationController?.navigationBar
  }
  
  private var isNavigationBarAtTop: Bool = true
  
  private var initialTopContentOffset: CGPoint!
  
  private var imageTopConstraintOnTop: NSLayoutConstraint?
  private var imageTopConstraintOnTheOthers: NSLayoutConstraint?
  
  private lazy var originalImageViewHeight: CGFloat = imageContentView.frame.height
  
  private var detailPlaceMainInfoViewHeightConstraint: NSLayoutConstraint?
  
  // MARK: - Navigation Bar Items
  
  private lazy var backBarButton: UIBarButtonItem = {
    let backBarButton = UIBarButtonItem(image: UIImage(named: "Back"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(didTapBackButton))
    
    return backBarButton
  }()
  
  private lazy var phoneBarButton: UIBarButtonItem = {
    
    let phoneBarButton = UIBarButtonItem(image: UIImage(named: "Phone"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapPhoneButton))
    
    
    
    return phoneBarButton
  }()
  
  private lazy var loveBarButton: UIBarButtonItem = {
    
    let loveButton = UIButton()
    loveButton.setImage(UIImage(named: "EmptyLove"), for: .normal)
    loveButton.setBackgroundImage(UIImage(named:"FilledLove"), for: .selected)
    
    loveButton.addTarget(self, action: #selector(didTapLoveButton(sender:)), for: .touchUpInside)
    
    return UIBarButtonItem(customView: loveButton)
  }()
  
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    _ = originalImageViewHeight
      
    setUpScrollView()
    
    setUpNavigationBar()
    
    setUpImageContentContstraints()
    
    setUpVerticalStackView()
  }
  
  
  // MARK: - Custom
  
  func setDetailPlaceData(with data: DetailPlaceType) {
    // TODO: 화면 구성에 필요한 데이터( 링크 형태든, 구조체 형태든 0 를 초기화하는 함수
    
    detailPlaceData = data
  }
  
  private func setUpScrollView() {
    
    scrollView.delegate = self
    
    scrollView.contentInsetAdjustmentBehavior = .never
    
    initialTopContentOffset = scrollView.contentOffset
  }
  
  private func setUpNavigationBar() {
    
    toggleNavigationBar()
    
    self.navigationItem.setLeftBarButton(backBarButton, animated: true)
    self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0,
                                                                      left: 8,
                                                                      bottom: 0,
                                                                      right: 0)
    
    // 16 만큼 띄우기 위한 코드
    self.navigationItem.setRightBarButtonItems([loveBarButton, phoneBarButton], animated: true)
  }
  
  private func setUpImageContentContstraints() {
    
    imageTopConstraintOnTop = imageContentView.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor)
    
    imageTopConstraintOnTop?.isActive = true
    
    imageTopConstraintOnTheOthers = imageContentView.topAnchor.constraint(equalTo: contentView.topAnchor)
  }
  
  // MARK: - 스택 뷰의 서브뷰 추가 작업
  
  private func setUpVerticalStackView() {
    
    let mainInfoView = DetailPlaceMainInfoView.instantiateFromNib()
    
    verticalStackView.addArrangedSubview(mainInfoView)
    
    let basicInfoView = DetailPlaceBasicInfoView.instantiateFromNib()
    
    basicInfoView.setPhoneNumberLabelText(with: "010-1234-5678")
    
    verticalStackView.addArrangedSubview(basicInfoView)
    
    
    
  }
  
  @objc private func didTapLoveButton(sender: UIButton) {
    
    sender.isSelected = sender.isSelected ? false : true
    
    // TODO: 좋아요 해제 작업
  }
  
  /// https://stackoverflow.com/questions/40078370/how-to-make-phone-call-in-ios-10-using-swift
  @objc func didTapPhoneButton() {
    
    // TODO: Alert 창 띄우고, 확인 누를 때 전화 앱으로 이동
//    var number = "010-5131-9925"
//    guard let number = URL(string: "tel://" + number) else { return }
//    UIApplication.shared.open(number)
  }
  
  @objc func didTapBackButton() {
    
    self.navigationController!.popViewController(animated: true)
  }
  
  // MARK: - 높이 변경 때문에
  @objc func didTapExpandButton(sender: UIButton) {
    
    guard let infoView = sender.superview as? DetailPlaceMainInfoView else { fatalError( #function) }
    
    sender.isSelected.toggle()
    
    detailPlaceMainInfoViewHeightConstraint?.constant = 600
    
    infoView.customInfoLabel.numberOfLines = infoView.customInfoLabel.numberOfLines == 3 ? 10 : 3
  }
  
  
  
  /**
    Toggle layout of Navigation Bar on ScrollView's Content Offset.
   
   If Scroll is at the top-most offset, Navigation Bar turns into clear-theme.
   
   - Parameters
      - atTop:  Boolean if Scroll is at the top-most offset

   */
  private func toggleNavigationBar(atTop: Bool = true) {
    
    switch atTop {
      
      case true:
        
        self.navigationBar?.standardAppearance.configureWithTransparentBackground()
        
        self.navigationItem.title = nil
        
        self.navigationBar?.tintColor = .white
        
        self.navigationBar?.backgroundColor = .clear
        
        
      case false:
        
        self.navigationBar?.standardAppearance.configureWithOpaqueBackground()
        
        self.navigationItem.title = "제주코기네"
        
        self.navigationBar?.tintColor = .black

    }
  }
}

// MARK: - Stroyboardable

extension DetailAccomodationsViewController: Storyboardable { }

// MARK: - UIScrollViewDelegate

extension DetailAccomodationsViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
    /// Scroll offset at Top -> the others
    if initialTopContentOffset.y < scrollView.contentOffset.y, isNavigationBarAtTop {

      isNavigationBarAtTop.toggle()
      toggleNavigationBar(atTop: isNavigationBarAtTop)
      
      imageTopConstraintOnTop?.isActive.toggle()
      imageTopConstraintOnTheOthers?.isActive.toggle()
      
      scrollView.insetsLayoutMarginsFromSafeArea = false
      
      return
    }

    /// Scroll offset at the others -> Top
    if initialTopContentOffset.y - scrollView.contentOffset.y > 0, !isNavigationBarAtTop {

      isNavigationBarAtTop.toggle()
      toggleNavigationBar(atTop: isNavigationBarAtTop)
      
      imageTopConstraintOnTheOthers?.isActive.toggle()
      imageTopConstraintOnTop?.isActive.toggle()
      
      return
    }
    
    /// FrameLayout Guide TopAnchor 에 제약이 걸린 상태로
    /// 이미지 뷰의 높이를 증가시켜 준다.
    if initialTopContentOffset!.y - scrollView.contentOffset.y >= 0 {

      imageContentHeightConstraint.constant = originalImageViewHeight + -(scrollView.contentOffset.y)
    }
  }
}
