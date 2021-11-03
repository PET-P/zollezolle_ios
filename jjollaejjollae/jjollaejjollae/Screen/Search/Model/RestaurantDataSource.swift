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
      if newDataList.isEmpty {
        guard let vc = CallerVC as? SearchResultViewController else {return}
        vc.goToMapButton.isHidden = true
      } else {
        guard let vc = CallerVC as? SearchResultViewController else {return}
        vc.goToMapButton.isHidden = false
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
      guard let token = UserManager.shared.userIdandToken?.token,
            let userId = UserManager.shared.userIdandToken?.userId else {return}
      APIService.shared.deletePlaceInFolder(token: token, userId: userId, folderId: nil, placeId: placeId) { result in
        switch result {
        case .success(let data):
          print(data)
        case .failure(let error):
          print(error)
        }
      }
    } else {
      likes[placeId] = true
      guard let wishListMainVC = WishlistMainViewController.loadFromStoryboard() as? WishlistMainViewController else {
        return
      }
      wishListMainVC.setPlaceInfo(placeId: placeId)
      wishListMainVC.setMode(mode: .fromCell)
      wishListMainVC.delegate = CallerVC as? SearchDataReceiveable
      CallerVC?.present(wishListMainVC, animated: true, completion: nil)
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
    cell.starPointLabel.text = String(format: "%.1f", item.reviewPoint ?? 0)
    
    cell.isWish = likes[cell.placeId] == true
    newDataList[indexPath.row].isWish = likes[cell.placeId] == true //이것의 이유?
    return cell
  }
  
}

