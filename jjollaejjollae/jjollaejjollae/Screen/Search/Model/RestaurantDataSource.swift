//
//  RestaurantDataSource.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

class RestaurantDataSource: NSObject, UITableViewDataSource {
  var newDataList: [SearchResultData] = [] {
    didSet {
      newDataList.forEach { (data) in
        likes.updateValue(data.isWish ?? false, forKey: data.id)
      }
    }
  }
  lazy var likes: [String: Bool] = [:]
  private var CallerVC: UIViewController?
  internal func setCallerVC(viewController: UIViewController) {
    CallerVC = viewController
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newDataList.count
  }
}

extension RestaurantDataSource: SearchResultCellDelegate {
  
  func didTapHeart(for placeId: String, like: Bool) {
    if like {
      likes[placeId] = false
    } else {
      likes[placeId] = true
      guard let wishListMainVC = WishlistMainViewController.loadFromStoryboard() as? WishlistMainViewController else {
        return
      }
      CallerVC?.present(wishListMainVC, animated: true, completion: nil)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell
    else { return UITableViewCell() }
    
    cell.delegate = self
    cell.placeId = newDataList[indexPath.row].id
    
    let item = newDataList[indexPath.row]
    
    cell.locationNameLabel.text = item.title
    cell.locationTypeLabel.text = nil
    cell.numberOfReviewsLabel.text = "(\(item.reviewCount))"
    cell.starPointLabel.text = " \(item.reviewPoint ?? 0)"
    
    cell.isWish = likes[cell.placeId] == true
    newDataList[indexPath.row].isWish = likes[cell.placeId] == true //이것의 이유?
    return cell
  }
  
}

