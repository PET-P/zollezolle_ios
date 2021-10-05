//
//  HomeMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class HomeMainViewController: UIViewController, StoryboardInstantiable {
  
  // MARK: - IBOutlet
  
  @IBOutlet weak var imageBackView: UIView!
  
  @IBOutlet weak var imageBackViewHeightConstraint: NSLayoutConstraint! {
    didSet {
      
      imageBackViewHeightConstraint.constant = mainImageMaxHeight
    }
  }

  @IBOutlet weak var mainImageView: UIImageView! {
    didSet {

      if hasMainPhoto {
        // TODO: 프로필 사진 설정
        
        return
      }
      
      // mainImageView.image = SomedefaultImage
    }
  }
  
  @IBOutlet weak var mainScrollView: UIScrollView! {
    didSet {
      
      mainScrollView.contentInsetAdjustmentBehavior = .never
      
      mainScrollView.contentInset.top = mainImageView.frame.height
      
      mainScrollView.showsVerticalScrollIndicator = false
    }
  }
  
  // MARK: - Protperty
  
  private var mainImageMaxHeight: CGFloat = 360
  private var mainImageMinHeight: CGFloat = 128
  
  
  private var hasMainPhoto: Bool {
    // MainPhoto 유무 확인하는 로직
    return true
  }
  
  private var userPetName: String? {
    return "쪼꼬"
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    mainScrollView.delegate = self
  }
  
  // MARK: - Custom

}

extension HomeMainViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    mainImageView.alpha = ((mainImageView.frame.height - mainImageMinHeight) / (mainImageMaxHeight - mainImageMinHeight) * 100).rounded(.down)
    
    let value = mainImageMaxHeight - scrollView.contentOffset.y.rounded(.up) - CGFloat(356)
    
    if value >= mainImageMinHeight && value <= mainImageMaxHeight {
      imageBackViewHeightConstraint.constant = value
    }

  func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    print(#function)
  }
}
