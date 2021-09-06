//
//  SearchResultDataSource.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

class SearchResultDataSource: NSObject, UITableViewDataSource {
  var dataList : [SearchResultInfo] = []
  lazy var likes: [Int: Bool] = [:]
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    return list.count
    return 4
  }
}

extension SearchResultDataSource: SearchResultCellDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
            as? SearchResultTableViewCell else { return UITableViewCell()}
    
    cell.delegate = self
    cell.index = indexPath.row
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
  
  func didTapHeart(for placeId: Int, like: Bool) {
    //WISHLIST: 프로퍼티리스트를 바로바로 update시키고싶다
    if like {
      likes[placeId] = true
      //모델의 likes에 대한 Update
    } else {
      likes[placeId] = false
      //모델의 likes에 대한 Update
    }
  }

}