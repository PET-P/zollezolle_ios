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
  
  @IBOutlet weak var locationCollectionView: UICollectionView!
  
  @IBOutlet weak var homeTipCollectionView: UICollectionView!
  
  @IBOutlet weak var recommendedPlaceCollectionView: UICollectionView!
  
  
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
    

    UserDefaults.standard.register(defaults: ["UserAgent" : "Safari/xyz"])

    setUpLocationCollectionView()
    
    setUpHomeTipCollectionView()
    
    setUpRecommendedCollectionView()
    
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
    
    locationCollectionView.showsHorizontalScrollIndicator = false
    
    let layout = locationCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
    layout.itemSize = CGSize(width: 138, height: 72)
    layout.minimumLineSpacing = 15
    layout.scrollDirection = .horizontal
    
    locationCollectionView.delegate = self
    locationCollectionView.dataSource = self
    
    let locationCellNib = UINib(nibName: HomeLocationCollectionViewCell.identifier, bundle: nil)
    
    locationCollectionView.register(locationCellNib, forCellWithReuseIdentifier: HomeLocationCollectionViewCell.identifier)
  }
  
  /**
   HoneyTipCollectionView 기본 셋업 메서드
  */
 
  
  func setUpHomeTipCollectionView() {
    
    homeTipCollectionView.showsHorizontalScrollIndicator = false
    
    let layout = homeTipCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
    layout.itemSize = CGSize(width: 116, height: 120)
    layout.minimumLineSpacing = 15
    layout.scrollDirection = .horizontal
    
    homeTipCollectionView.delegate = self
    homeTipCollectionView.dataSource = self
    
    let tipCellNib = UINib(nibName: HomeTipCollectionViewCell.identifier, bundle: nil)
    
    homeTipCollectionView.register(tipCellNib, forCellWithReuseIdentifier: HomeTipCollectionViewCell.identifier)
  }
  
  
  
  /**
    RecommendedCollectionView 기본 셋업 메서드
   */
  
  func setUpRecommendedCollectionView() {
    
    recommendedPlaceCollectionView.showsHorizontalScrollIndicator = false
    
    let layout = recommendedPlaceCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
    layout.itemSize = CGSize(width: 138, height: 72)
    layout.minimumLineSpacing = 15
    layout.scrollDirection = .horizontal
    
    recommendedPlaceCollectionView.delegate = self
    recommendedPlaceCollectionView.dataSource = self
    
    let locationCellNib = UINib(nibName: HomeLocationCollectionViewCell.identifier, bundle: nil)
    
    recommendedPlaceCollectionView.register(locationCellNib, forCellWithReuseIdentifier: HomeLocationCollectionViewCell.identifier)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    
    if let vc = segue.destination as? UINavigationController, let url = sender as? String {
      
      if let tipVC = vc.viewControllers.first! as? TipWebViewController {
        
        tipVC.targetURLString = url
      }

    }
  }
}

extension HomeMainViewController: UICollectionViewDataSource {
  
  enum LocationType: String, CaseIterable {
    
    case goodRestaurant
    case cafe
    case attraction
    case accomodation
    
    var description: String {
      
      switch self {
        
        case .goodRestaurant:
          return "맛집"
        case .cafe:
          return "카페"
        case .attraction:
          return "관광지"
        case .accomodation:
          return "숙소"
      }
    }
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView === locationCollectionView {
      return LocationName.allCases.count
    }
    
    if collectionView === homeTipCollectionView {
      return HomeTipCollectionViewCell.tipDataList.count
    }
    
    if collectionView === recommendedPlaceCollectionView {
      return LocationType.allCases.count
    }

    return 10
  }

  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView === locationCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeLocationCollectionViewCell.identifier, for: indexPath)
      
      guard let locationCell = cell as? HomeLocationCollectionViewCell else { return UICollectionViewCell() }
      
      let locationName = LocationName.allCases[indexPath.row].description
      
      locationCell.titleLabel.text = locationName
      locationCell.mainImageView.image = UIImage(named: locationName)
      
      return locationCell
    }
    
    if collectionView === homeTipCollectionView {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTipCollectionViewCell.identifier, for: indexPath)
      
      guard let tipCell = cell as? HomeTipCollectionViewCell else { return UICollectionViewCell() }
      
      let data = HomeTipCollectionViewCell.tipDataList[indexPath.item]
      
      tipCell.titleLabel.text = data.title
      tipCell.emojiLabel.text = data.emoji
      
      return tipCell
    }
    
    if collectionView === recommendedPlaceCollectionView {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeLocationCollectionViewCell.identifier, for: indexPath)
      
      guard let locationCell = cell as? HomeLocationCollectionViewCell else { return UICollectionViewCell() }
      
      locationCell.titleLabel.text = LocationType.allCases[indexPath.item].description
      locationCell.mainImageView.image = UIImage(named: LocationType.allCases[indexPath.item].rawValue)
      
      return locationCell
      
    }
    
    return UICollectionViewCell()
  }
}


// MARK: - UICollectionViewDelegate

extension HomeMainViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if collectionView === locationCollectionView {
      
      print(#function)
    }
    
    if collectionView === homeTipCollectionView {
      
      print(#function)
      
      let urlString = HomeTipCollectionViewCell.tipDataList[indexPath.item].urlString
      
      performSegue(withIdentifier: "TipWebSegue", sender: urlString)
      
    }
    
    
    if collectionView === recommendedPlaceCollectionView {
      
      print(#function)
    }
  
  }
  
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

