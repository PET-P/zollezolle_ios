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
  
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    mainScrollView.delegate = self
    
    let layout = firstCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
    layout.itemSize = CGSize(width: 138, height: 72)
    layout.minimumLineSpacing = 15
    layout.scrollDirection = .horizontal
    collectionView.contentInset = UIEdgeInsets(top: 14, left: 16, bottom: insetY, right: 16)

    
    firstCollectionView.delegate = self
    firstCollectionView.dataSource = self
    
    let cellNib = UINib(nibName: homeLocationCellNibName, bundle: nil)
    
    firstCollectionView.register(cellNib, forCellWithReuseIdentifier: homeLocationCellNibName)
//
//    secondCollectionView.delegate = self
//    secondCollectionView.dataSource = self
//    
//    // TODO: HomeTipCell 로 변경
//    secondCollectionView.register(cellNib, forCellWithReuseIdentifier: homeLocationCellNibName)
//
//    thirdCollectionView.delegate = self
//    thirdCollectionView.dataSource = self
//    
//    thirdCollectionView.register(cellNib, forCellWithReuseIdentifier: homeLocationCellNibName)
    
  }
  
  // MARK: - Custom

}

extension HomeMainViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    mainImageView.alpha = ((mainImageView.frame.height - mainImageMinHeight) / (mainImageMaxHeight - mainImageMinHeight))
    
    
    print(mainImageView.alpha)
    imageBackView.setNeedsDisplay()
    
    let value = mainImageMaxHeight - scrollView.contentOffset.y.rounded(.up) - CGFloat(356)
    
    if value >= mainImageMinHeight && value <= mainImageMaxHeight {
      imageBackViewHeightConstraint.constant = value
    }


  }
  
  func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    print(#function)
  }
}

extension HomeMainViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeLocationCellNibName, for: indexPath) as? HomeLocationCollectionViewCell else { fatalError(#function) }

//    guard let cell = cell as? HomeLocationCollectionViewCell else { fatalError(#function) }
//
//    cell.imageView.image = UIImage(systemName: "heart")
//    cell.titleLabel.text = "TESTTEST"
    
    cell.heightAnchor.constraint(equalToConstant: 72).isActive = true
    cell.widthAnchor.constraint(equalToConstant: 138).isActive = true

    return cell

  }
}

extension HomeMainViewController: UICollectionViewDelegate {

}



