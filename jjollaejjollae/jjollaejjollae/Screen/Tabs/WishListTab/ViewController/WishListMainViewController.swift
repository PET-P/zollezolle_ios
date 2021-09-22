//
//  WishListMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class WishlistMainViewController: UIViewController {
  
  @IBOutlet weak var closeButton: UIButton!
  
  @IBOutlet weak var addWishlistButton: UIButton! {
    didSet {
      applyDesign(to: addWishlistButton)
    }
  }
  
  @IBOutlet weak var showEntireWishlistButton: UIButton! {
    didSet {
      applyDesign(to: showEntireWishlistButton)
    }
  }
  
  @IBOutlet weak var wishlistCollectionView: UICollectionView! {
    didSet {
      wishlistCollectionView.dataSource = self
      wishlistCollectionView.delegate = self
      wishlistCollectionView.showsVerticalScrollIndicator = false
    }
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
    // Modal 방식으로 화면에 나오지 않았다면 닫기 버튼을 숨긴다.
    if presentingViewController == nil {
      setCloseButtonHidden()
    }
    
    super.viewDidLoad()
    self.modalPresentationStyle = .pageSheet
    setUpWishlistCollectionView()
  }
  
  // MARK: - IBActions
  
  @IBAction func didTapAddWishlist(_ sender: UIButton) {
    print(#function)
  }
  
  @IBAction func didTapShowEntireWishlist(_ sender: Any) {
    print(#function)
  }
  
  // MARK: - Custom Instance
  
  /**
    WishlistCollectionView 의 초기설정 코드
   */
  private func setUpWishlistCollectionView() {
    

  }
  
  private func setCloseButtonHidden (){
    if presentingViewController == nil {
      closeButton.isHidden = true
      return
    }
  }
  
  // TODO: 이 스타일 적용할 수 있는 클래스를 분리해볼 수 있겠다.
  // 다른 VC 에서도 재사용할 수 있게
  /**
    WishlistMainVC 를 위한 버튼/셀 디자인 적용 메서드
   */
  
  private func applyDesign<View: UIView>(to view: View) {
    view.layer.borderColor = UIColor.gray04.cgColor
    view.layer.borderWidth = 2
    view.layer.cornerRadius = 8
  }
}

extension WishlistMainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = collectionView.dequeueReusableCell(withReuseIdentifier: "wishlistItem", for: indexPath) as! WishlistCollectionViewCell
    
    
    // TODO: Data 전체를 넘겨줄지, Cell Layout 구성에 필요한 Data 만 넘겨줄지는 고민해야함
    
//    item.fillContent(with: WishlistData)
    
    applyDesign(to: item)
    
    return item
  }
}

extension WishlistMainViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let wishlistVC = WishlistViewController.loadFromStoryboard()
    
    // TODO: wishListVC 를 적절한 데이터를 사용해 채워넣는 코드
    
    self.navigationController?.pushViewController(wishlistVC, animated: true)

  }
}

extension WishlistMainViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let figmaDefinedHeightValue: CGFloat = 86
    
    let width = wishlistCollectionView.frame.width - 1
    let height = figmaDefinedHeightValue
    
    return CGSize(width: width, height: height)
  }
}

// MARK: - Storyboard
// TODO: StoryboardInstantiable 로 대체해야 한다.
extension WishlistMainViewController: StoryboardInstantiable { }

