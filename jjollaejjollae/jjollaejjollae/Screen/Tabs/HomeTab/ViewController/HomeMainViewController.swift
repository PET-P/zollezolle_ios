//
//  HomeMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

final class HomeMainViewController: UIViewController, StoryboardInstantiable, Searchable {
  
  private let userManager = UserManager.shared
  
  // MARK: - IBOutlet
  
  @IBOutlet weak var imageBackView: UIView!
  
  @IBOutlet weak var imageBackViewHeightConstraint: NSLayoutConstraint! {
    didSet {
      
      imageBackViewHeightConstraint.constant = mainImageMaxHeight
    }
  }
  
  @IBOutlet weak var mainLogoImageView: UIImageView!
  
  @IBOutlet weak var mainImageView: UIImageView!
  
  
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
      searchGuideLabel.text = "쪼꼬랑 어디로 가볼까요?"
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
  
  /**
   사용자가 설정한 대표 반려동물
   */
  
  private var representedPet: PetData? {
    didSet {
      updateMainImageView()
      updateSearchGuideLabel()
    }
  }
  
  
  /**
   Author : 박우찬
   NibName 과 reuseIdentifier 를 동일하게 설정
   */

  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(changeMainImage), name: UserManager.didSetAppUserNotification, object: nil)
    
    updateRepresentedPet()
    
    mainScrollView.delegate = self
    
    setUpLocationCollectionView()
    
    setUpHomeTipCollectionView()
    
    setUpRecommendedCollectionView()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.tabBarController?.tabBar.isHidden = false
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let vc = segue.destination as? UINavigationController, let url = sender as? String {
      
      if let tipVC = vc.viewControllers.first! as? TipWebViewController {
        
        tipVC.targetURLString = url
      }
    }
  }
  
  // MARK: - IBAction
  
  @IBAction func didTapSearchButton(_ sender: UIButton!) {
    guard let searchVC = SearchViewController.loadFromStoryboard() as? SearchViewController else { return }
    
    searchVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(searchVC, animated: true)

  }
  
  // MARK: - Custom
  
  @objc func changeMainImage() {
    
    guard let userInfo = userManager.userInfo else { return }

    guard let pet = userInfo.pets.filter({ petData in
      petData.isRepresent
    }).first else { return }

    guard let imageUrl = pet.imageUrl else { return }
    updateRepresentedPet()

    mainImageView.setImage(with: imageUrl)
    mainLogoImageView.isHidden = true
    
    
    LoadingIndicator.hide()
    return
  }
  
  private func updateMainImageView() {
    
    if let imageUrl = representedPet!.imageUrl {
      mainImageView.setImage(with:imageUrl)
      mainLogoImageView.isHidden = true
    }
  }
  
  private func updateSearchGuideLabel() {
    
    searchGuideLabel.textColor = .gray03
    
    let representedPetName = representedPet?.name ?? "쪼꼬"
    
    let modifiedName = representedPetName.appendedPostPositionText()
    searchGuideLabel.text = "\(modifiedName) 어디로 가볼까요?"
  }
  
  /**
   LocationCollectionView 기본 셋업 메서드
   */
  func setUpLocationCollectionView() {
    
    locationCollectionView.showsHorizontalScrollIndicator = false
    
    let layout = locationCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
    layout.itemSize = CGSize(width: 138, height: 72)
    layout.minimumLineSpacing = 15
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 40)
    
    locationCollectionView.collectionViewLayout = layout
    
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
    layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20)
    
    homeTipCollectionView.collectionViewLayout = layout
    
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
    layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20)
    
    recommendedPlaceCollectionView.collectionViewLayout = layout
    
    recommendedPlaceCollectionView.delegate = self
    recommendedPlaceCollectionView.dataSource = self
    
    let locationCellNib = UINib(nibName: HomeLocationCollectionViewCell.identifier, bundle: nil)
    
    recommendedPlaceCollectionView.register(locationCellNib, forCellWithReuseIdentifier: HomeLocationCollectionViewCell.identifier)
  }
  
  func updateRepresentedPet() {
    
    guard let userInfo = userManager.userInfo else { return }
    
    guard !(userInfo.pets.isEmpty) else { return }
    
    guard let pet = userInfo.pets.filter({ petData in
      petData.isRepresent
    }).first else { return }
    
    representedPet = pet
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
      
      let locationName = LocationName.allCases[indexPath.row].description
      SearchManager.shared.searchText = locationName
      
      switch UserManager.shared.userIdandToken {
        
      case .some( _, let token):
        
        guard let token = token else { return }
        
        LoadingIndicator.show()
        
        APIService.shared.search(token: token, keyword: locationName, page: 0) { result in
          
          switch result {
            
          case .success(let data):
            
            guard let nextVC = self.sendRightVC(from: self, by: data.region, regionCount: data.regionCount, with: data.result) as? UIViewController & SearchDataReceiveable else { return }
            
            print(self, data.result)
            
            nextVC.newDataList = data.result
              
            nextVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(nextVC, animated: true) {
              LoadingIndicator.hide()
            }
            
          case .failure(let error):
            
            print(self, #function, error)
            LoadingIndicator.hide()
          }
        }
        
      case .none:
        
        LoadingIndicator.show()
        
        APIService.shared.search(keyword: locationName, page: 0) { result in
          
          switch result {
            
          case .success(let data):
            
            guard let nextVC = self.sendRightVC(from: self, by: data.region, regionCount: data.regionCount, with: data.result) as? UIViewController & SearchDataReceiveable else { return }
            
            print(self, data.result)
            
            nextVC.newDataList = data.result

            nextVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(nextVC, animated: true) {
              LoadingIndicator.hide()
            }
            
          case .failure(let error):
            
            print(self, #function, error)
            LoadingIndicator.hide()
          }
        }
      }
    }
    
    /**
     쫄랭이의 여행 꿀팁
     */
    
    if collectionView === homeTipCollectionView {
      
      print(#function)
      
      let urlString = HomeTipCollectionViewCell.tipDataList[indexPath.item].urlString
      
      performSegue(withIdentifier: "TipWebSegue", sender: urlString)
      
    }
    
    /**
     쪼꼬와 비슷한 친구들에게 인기 있는 장소
     */
    
    if collectionView === recommendedPlaceCollectionView {
      
      let recommendName = ["식당", "카페", "명소", "숙소"]
      
      let lat = UserManager.shared.locationService.currentLocation.latitude
      let lng = UserManager.shared.locationService.currentLocation.longitude
      
      LoadingIndicator.show()
      
      APIService.shared.nearPlace(latitude: lat, longitude: lng) { (result) in
        
        switch result {
          
        case .success(let data):
          
          SearchManager.shared.searchText = recommendName[indexPath.row]
          
          let filteredData = data.filter({ (data) in
            return data.category.rawValue == recommendName[indexPath.row]
          })
          
          guard let nextVC = SearchResultViewController.loadFromStoryboard() as? SearchResultViewController else {return}
          nextVC.setMode(from: self)
          nextVC.newDataList = filteredData
          
          nextVC.hidesBottomBarWhenPushed = true
          
          self.navigationController?.pushViewController(nextVC, animated: true) { LoadingIndicator.hide() }
          
        case .failure(let error):
          
          print(self, #function, error)
          LoadingIndicator.hide()
          
        }
      }
    }
  }
  
}

extension HomeMainViewController: UICollectionViewDelegateFlowLayout {
  
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//    return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//  }
  
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    switch collectionView {
//      case locationCollectionView:
//        return CGSize(width: 137, height: 72)
//      case homeTipCollectionView:
//        return CGSize(width: 137, height: 72)
//      case recommendedPlaceCollectionView:
//        return CGSize(width: 137, height: 72)
//      default:
//        <#code#>
//    }
//  }
}



// MARK: - UIScrollViewDelegate

extension HomeMainViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    mainImageView.alpha = ((mainImageView.frame.height - mainImageMinHeight) / (mainImageMaxHeight - mainImageMinHeight))
    
    if !mainLogoImageView.isHidden {
      mainLogoImageView.alpha = ((mainImageView.frame.height - mainImageMinHeight) / (mainImageMaxHeight - mainImageMinHeight))
    }

    let value = mainImageMaxHeight - scrollView.contentOffset.y.rounded(.up) - CGFloat(356)
    
    if value >= mainImageMinHeight && value <= mainImageMaxHeight {
      imageBackViewHeightConstraint.constant = value
    }
  }
}

