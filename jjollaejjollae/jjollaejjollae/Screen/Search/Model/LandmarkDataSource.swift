//
//  LandmarkDataSource.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

class LandmarkDataSource: NSObject, UITableViewDataSource {
  var newDataList: [SearchResultData] = [] {
    didSet {
      newDataList.forEach { (data) in
        likes.updateValue(data.isWish ?? false, forKey: data.id)
      }
    }
  }
  // id, addresss, title, category, reviewCount, reviewPoint, 가격, wishlist
  lazy var likes: [String: Bool] = [:]
  private var CallerVC: UIViewController?
  internal func setCallerVC(viewController: UIViewController) {
    CallerVC = viewController
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //return landmarkDataList.count
    return newDataList.count
  }
}

extension LandmarkDataSource: SearchResultCellDelegate {
  
  func didTapHeart(for placeId: String, like: Bool) {
    //WISHLIST: 프로퍼티리스트를 바로바로 update시키고싶다
    if like {
      likes[placeId] = false
      
      //모델의 likes에 대한 Update
    } else {
      likes[placeId] = true
      guard let wishListMainVC = WishlistMainViewController.loadFromStoryboard() as? WishlistMainViewController else {
        return
      }
      wishListMainVC.setPlaceInfo(placeId: placeId)
      wishListMainVC.setMode(mode: .fromCell)
      CallerVC?.present(wishListMainVC, animated: true, completion: nil)
      //모델의 likes에 대한 Update
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell
    else { return UITableViewCell() }
  
    cell.delegate = self
    cell.placeId = newDataList[indexPath.row].id
    
    let item = newDataList[indexPath.row]
    
    cell.cellImageView.setImage(with: item.imagesUrl.first ?? "default")
    cell.addressLabel.text = item.address.joined(separator: " ")
    cell.locationNameLabel.text = item.title
    cell.locationTypeLabel.text = nil
    cell.numberOfReviewsLabel.text = "(\(item.reviewCount))"
    cell.starPointLabel.text = " \(item.reviewPoint ?? 0)"
    
    cell.isWish = likes[cell.placeId] == true
    newDataList[indexPath.row].isWish = likes[cell.placeId] == true //이것의 이유?
    
    return cell
  }
  
}
