//
//  HomeMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class HomeMainViewController: UIViewController {
  
	// MARK: - IBOutlets
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var searchField: UITextField!
  
  // TODO: CollectionView 연결
  
  @IBOutlet weak var recommendedPlaceCollectionView: UICollectionView!
  @IBOutlet weak var honeyTipCollectionView: UICollectionView!
  @IBOutlet weak var popularPlaceCollectionView: UICollectionView!
  
  
  lazy var searchButton: UIButton = {
    
    let button = UIButton()
    
    button.setImage(UIImage(named: "Search"), for: UIControl.State.normal)
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    setSearchField()
    setCollectionViews()
  }
  
  // MARK: - Custom
  
  private func setSearchField() {
    
    searchField.layer.cornerRadius = searchField.frame.height / 2
    searchField.layer.masksToBounds = true
    
    searchField.rightView = searchButton
    searchField.rightViewMode = .always
    
    searchField.addSubview(searchButton)
    
    searchButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    searchButton.heightAnchor.constraint(equalTo: searchButton.widthAnchor, multiplier: 1.0).isActive = true
    
    searchButton.centerYAnchor.constraint(equalTo: searchField.centerYAnchor).isActive = true
    searchButton.trailingAnchor.constraint(equalTo: searchField.trailingAnchor, constant: -20).isActive = true
  }
  private func setCollectionViews() {
    
    recommendedPlaceCollectionView.delegate = self
    recommendedPlaceCollectionView.dataSource = self
    
    honeyTipCollectionView.delegate = self
    honeyTipCollectionView.dataSource = self
    
    popularPlaceCollectionView.delegate = self
    popularPlaceCollectionView.dataSource = self
  }
}

// MARK: - Storyboradable
extension HomeMainViewController: Storyboardable{
  
//  static func loadFromStoryboard() -> UIViewController {
//    
//    let storyboard = UIStoryboard(name: fileName, bundle: nil)
//    
//    let homeMainVC = storyboard.instantiateViewController(identifier: storyboardIdentifier)
//    
//    return homeMainVC
//  }
}

// MARK: - UICollectionViewDataSource
extension HomeMainViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView === recommendedPlaceCollectionView {
      
      return 1
    }
    
    if collectionView === honeyTipCollectionView {
      
      return 1
    }
    
    if collectionView === popularPlaceCollectionView {
      
      return 1
    }
    
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView === recommendedPlaceCollectionView {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.recommendedPlaceCellID,
                                                    for: indexPath)
      return cell
    }
    
    if collectionView === honeyTipCollectionView {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.honeyTipCellID,
                                                    for: indexPath)
      return cell
    }
    
    if collectionView === popularPlaceCollectionView {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.popularPlaceCellID,
                                                    for: indexPath)
      return cell
    }
    
    return UICollectionViewCell()
  }
}

extension HomeMainViewController: UICollectionViewDelegate {
  
}

// MARK: - UICollectionvViewDelegateFlowLayout
extension HomeMainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if collectionView === recommendedPlaceCollectionView {
      return CGSize(width: 138, height: 72)
    }
    
    if collectionView === honeyTipCollectionView {
      return CGSize(width: 116, height: 120)
    }
    
    if collectionView === popularPlaceCollectionView {
      return CGSize(width: 138, height: 72)
    }
    
    // Default Value
    return CGSize(width: 50, height: 50)
  }
}
