//
//  AccommodationDataSource.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

class AccommodationDataSource: NSObject, UITableViewDataSource {
  var dataList: [SearchResultInfo] = []
  lazy var likes: [Int: Int] = [:]
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //return accommoDataList.count
    return 10
  }
}

extension AccommodationDataSource: SearchResultCellDelegate {
  
  func didTapHeart(for index: Int, like: Bool) {
    if like {
      likes[index] = 1
    } else {
      likes[index] = 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell
    else { return UITableViewCell() }
    
    cell.delegate = self
    cell.index = indexPath.row
    
    let item = dataList[indexPath.row]
    cell.locationNameLabel.text = item.name
    cell.locationTypeLabel.text = item.type
    cell.numberOfReviewsLabel.text = "(\(item.numbers))"
    cell.starPointLabel.text = "\(item.points)"
    
    cell.isWish = likes[indexPath.row] == 1 ? true : false
    dataList[indexPath.row].like = likes[indexPath.row] == 1 ? true : false
    
    
    return cell
  }
  
}
