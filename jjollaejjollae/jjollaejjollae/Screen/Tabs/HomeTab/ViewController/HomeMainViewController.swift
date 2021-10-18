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
  
  @IBOutlet weak var searchGuideLabel: UILabel! {
    didSet {
      searchGuideLabel.textColor = .gray03
      
      let representedPetName = representedPet?.name ?? "쪼꼬"
      
      let modifiedName = representedPetName.appendedPostPositionText()
      searchGuideLabel.text = "\(modifiedName) 어디로 가볼까요?"
    }
  }
  
  @IBOutlet weak var locationCollectionView: UICollectionView! {
    didSet {
      locationCollectionView.showsHorizontalScrollIndicator = false
    }
  }
  
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
      사용자가 설정한 대표 반려동물을 반환하는 계산속성
   */
  
  private var representedPet: PetData? {
    
    guard let userData = UserManager.shared.userInfo else { return nil }
    
    guard !(userData.pets.isEmpty) else { return nil }
    
    let petList = userData.pets
    
    var representedPet: PetData?
    
    petList.forEach { pet in
      
      if representedPet != nil  {
        return
      }
      
      if pet.isRepresent {
        representedPet = pet
      }
    }
    
    return representedPet
  }
  
  /**
    Author : 박우찬
    NibName 과 reuseIdentifier 를 동일하게 설정
   */
//  private let homeLocationCellNibName = "HomeLocationCell"
  
  private let homeTipCellNibName = "HomeTipCell"
  

  // MARK: - Life Cycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    mainScrollView.delegate = self
    

    

    setUpLocationCollectionView()
    
//    secondCollectionView.delegate = self
//    secondCollectionView.dataSource = self
////
//    let tipCellNib = UINib(nibName: homeTipCellNibName, bundle: nil)
//    // TODO: HomeTipCell 로 변경
//    secondCollectionView.register(tipCellNib, forCellWithReuseIdentifier: homeTipCellNibName)

//    thirdCollectionView.delegate = self
//    thirdCollectionView.dataSource = self
//
//    thirdCollectionView.register(locationCellNib, forCellWithReuseIdentifier: homeLocationCellNibName)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  // MARK: - IBAction
  
  @IBAction func didTapSearchButton(_ sender: UIButton!) {
    guard let searchVC = SearchViewController.loadFromStoryboard() as? SearchViewController else { return }
    
    self.navigationController?.pushViewController(searchVC, animated: true)
  }
  
  // MARK: - Custom
  
  /**
    LocationCollectionView 기본 셋업 메서드
   */
  func setUpLocationCollectionView() {
    
    let layout = locationCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
    layout.itemSize = CGSize(width: 138, height: 72)
    layout.minimumLineSpacing = 15
    layout.scrollDirection = .horizontal
    
    locationCollectionView.delegate = self
    locationCollectionView.dataSource = self
    
    let locationCellNib = UINib(nibName: HomeLocationCollectionViewCell.identifier, bundle: nil)
    
    locationCollectionView.register(locationCellNib, forCellWithReuseIdentifier: HomeLocationCollectionViewCell.identifier)
  }

}


extension HomeMainViewController: UICollectionViewDataSource {
  
  enum Location: CaseIterable {
    case seoul
    case sokcho
    case gangneung
    case yeosu
    case gyeongju
    case daegu
    case jeju
    
    var description: String {
      
      switch self {
        case .seoul:
          return "서울"
        case .sokcho:
          return "속초"
        case .gangneung:
          return "강릉"
        case .yeosu:
          return "여수"
        case .gyeongju:
          return "경주"
        case .daegu:
          return "대구"
        case .jeju:
          return "제주"
      }
    }
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView === locationCollectionView {
      return Location.allCases.count
    }

    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    
    if collectionView === locationCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeLocationCollectionViewCell.identifier, for: indexPath)
      
      guard let locationCell = cell as? HomeLocationCollectionViewCell else { return UICollectionViewCell() }
      locationCell.mainImageView.image = UIImage(named: Location.allCases[indexPath.item].description)
      
      return locationCell
    } else {
      return UICollectionViewCell()
    }
    
//
//
//    if collectionView === secondCollectionView {
//      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeTipCellNibName, for: indexPath) as? HomeTipCollectionViewCell else { fatalError(#function) }
//
//      cell.heightAnchor.constraint(equalToConstant: 120).isActive = true
//      cell.widthAnchor.constraint(equalToConstant: 116).isActive = true
//
//      return cell
//
//    } else {
//      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeLocationCellNibName, for: indexPath) as? HomeLocationCollectionViewCell else { fatalError(#function) }
//
//      cell.heightAnchor.constraint(equalToConstant: 72).isActive = true
//      cell.widthAnchor.constraint(equalToConstant: 138).isActive = true
//
//      return cell
//
//    }
//
  }
  
  
  
}

extension HomeMainViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if collectionView === locationCollectionView {
      
//      let resultVC = SearchNoResultViewControlle
      
//      self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
    }
  }
  
  
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


// MARK: - UIScrollViewDelegate

extension HomeMainViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    mainImageView.alpha = ((mainImageView.frame.height - mainImageMinHeight) / (mainImageMaxHeight - mainImageMinHeight))
    
    let value = mainImageMaxHeight - scrollView.contentOffset.y.rounded(.up) - CGFloat(356)
    
    if value >= mainImageMinHeight && value <= mainImageMaxHeight {
      imageBackViewHeightConstraint.constant = value
    }
  }
}

