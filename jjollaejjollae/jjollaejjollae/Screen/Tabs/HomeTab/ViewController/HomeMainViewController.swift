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
  
  @IBOutlet weak var searchButton: UIButton! {
    didSet {
      searchButton.layer.cornerRadius = searchButton.frame.height / 2
    }
  }
  
  @IBOutlet weak var firstCollectionView: UICollectionView!
  @IBOutlet weak var secondCollectionView: UICollectionView!
  @IBOutlet weak var thirdCollectionView: UICollectionView!
  
  
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
  
  /**
    Author : 박우찬
    NibName 과 reuseIdentifier 를 동일하게 설정
   */
  private let homeLocationCellNibName = "HomeLocationCell"
  
  private let homeTipCellNibName = "HomeTipCell"

  // MARK: - Life Cycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    mainScrollView.delegate = self
    
    let layout = firstCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
    layout.itemSize = CGSize(width: 138, height: 72)
    layout.minimumLineSpacing = 15
    layout.scrollDirection = .horizontal
    
    firstCollectionView.delegate = self
    firstCollectionView.dataSource = self
    
    let locationCellNib = UINib(nibName: homeLocationCellNibName, bundle: nil)
  
    firstCollectionView.register(locationCellNib, forCellWithReuseIdentifier: homeLocationCellNibName)

    secondCollectionView.delegate = self
    secondCollectionView.dataSource = self
//
    let tipCellNib = UINib(nibName: homeTipCellNibName, bundle: nil)
    // TODO: HomeTipCell 로 변경
    secondCollectionView.register(tipCellNib, forCellWithReuseIdentifier: homeTipCellNibName)

    thirdCollectionView.delegate = self
    thirdCollectionView.dataSource = self
    
    thirdCollectionView.register(locationCellNib, forCellWithReuseIdentifier: homeLocationCellNibName)
    
  }
  
  // MARK: - Custom

}

extension HomeMainViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    mainImageView.alpha = ((mainImageView.frame.height - mainImageMinHeight) / (mainImageMaxHeight - mainImageMinHeight))
    
    let value = mainImageMaxHeight - scrollView.contentOffset.y.rounded(.up) - CGFloat(356)
    
    if value >= mainImageMinHeight && value <= mainImageMaxHeight {
      imageBackViewHeightConstraint.constant = value
    }
  }
}

extension HomeMainViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView === secondCollectionView {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeTipCellNibName, for: indexPath) as? HomeTipCollectionViewCell else { fatalError(#function) }
      
      cell.heightAnchor.constraint(equalToConstant: 120).isActive = true
      cell.widthAnchor.constraint(equalToConstant: 116).isActive = true

      return cell
      
    } else {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeLocationCellNibName, for: indexPath) as? HomeLocationCollectionViewCell else { fatalError(#function) }
      
      cell.heightAnchor.constraint(equalToConstant: 72).isActive = true
      cell.widthAnchor.constraint(equalToConstant: 138).isActive = true

      return cell
      
    }
    
  }
}

extension HomeMainViewController: UICollectionViewDelegate {
  
  /**
    CollectionView Cell Center Align
   */
  
//  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//
//      let totalCellWidth = CellWidth * CellCount
//      let totalSpacingWidth = CellSpacing * (CellCount - 1)
//
//      let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//      let rightInset = leftInset
//
//      return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//  }
}



