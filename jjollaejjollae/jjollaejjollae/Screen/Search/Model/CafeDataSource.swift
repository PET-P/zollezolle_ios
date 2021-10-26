//
//  CafeDataSource.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

class CafeDataSource: NSObject, UITableViewDataSource {
  var dataList: [SearchResultInfo] = []
  lazy var likes: [Int: Bool] = [:]
  private var CallerVC: UIViewController?
  internal func setCallerVC(viewController: UIViewController) {
    CallerVC = viewController
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //return dataList.count
    return 4
  }
}

extension CafeDataSource: SearchResultCellDelegate {
  
  func didTapHeart(for placeId: Int, like: Bool) {
    if like {
      likes[placeId] = false
    } else {
      likes[placeId] = true
      guard let wishListMainVC = WishlistMainViewController.loadFromStoryboard() as? WishlistMainViewController else {
        return
      }
      CallerVC?.present(wishListMainVC, animated: true, completion: nil)
    }
    // 여기서 그냥 placeID 넘겨줘~
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell
    else { return UITableViewCell() }
    
    cell.delegate = self
    cell.placeId = dataList[indexPath.row].id
    
    let item = dataList[indexPath.row]
    if let day = item.days, let address = item.location, let price = item.prices {
      cell.DaysLabel.isHidden = false
      cell.addressLabel.isHidden = false
      cell.priceLabel.isHidden = false
      cell.DaysLabel.text = "\(day)박 요금"
      cell.addressLabel.text = address
      cell.priceLabel.text = "\(price)원"
    } else {
      cell.addressLabel.text = nil
      cell.DaysLabel.text = nil
      cell.priceLabel.text = nil
      cell.contentStackView.removeArrangedSubview(cell.addressLabel)
    }
    
    cell.locationNameLabel.text = item.name
    cell.locationTypeLabel.text = item.type ?? ""
    cell.numberOfReviewsLabel.text = "(\(item.numbers ?? 0))"
    cell.starPointLabel.text = " \(item.points ?? 0)"
    
    cell.isWish = likes[cell.placeId] == true
    dataList[indexPath.row].like = likes[cell.placeId] == true
    
    return cell
  }
  
}
