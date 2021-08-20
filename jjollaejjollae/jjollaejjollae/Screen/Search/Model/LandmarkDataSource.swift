//
//  LandmarkDataSource.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

class LandmarkDataSource: NSObject, UITableViewDataSource {
  var dataList: [SearchResultInfo] = []
  lazy var likes: [Int: Bool] = [:]
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //return landmarkDataList.count
    return 10
  }
}

extension LandmarkDataSource: SearchResultCellDelegate {
  
  func didTapHeart(for placeId: Int, like: Bool) {
    if like {
      likes[placeId] = true
    } else {
      likes[placeId] = true
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell
    else { return UITableViewCell() }
    
    cell.delegate = self
    cell.index = indexPath.row
    cell.placeId = dataList[indexPath.row].id
    
    let item = dataList[indexPath.row]
    cell.locationNameLabel.text = item.name
    cell.locationTypeLabel.text = item.type
    cell.numberOfReviewsLabel.text = "(\(item.numbers))"
    cell.starPointLabel.text = "\(item.points)"
    
    cell.isWish = likes[cell.placeId] == true
    dataList[indexPath.row].like = likes[cell.placeId] == true
    
    return cell
  }
  
}
