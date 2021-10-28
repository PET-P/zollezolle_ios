//
//  AccommodationDataSource.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

class AccommodationDataSource: NSObject, UITableViewDataSource {
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
    //return accommoDataList.count
    return newDataList.count
  }
}

extension AccommodationDataSource: SearchResultCellDelegate {
  
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



// like userdefault 관리한다
// userdefaults 와 서버 간 통신은 ()언제한다?
// likes?
// 4가지 가각의 장소가 unique한 키를 가지고 있어야한다.
// 어레이에 너허어서 확인해본다 O(n)
// dict O(1)
// 1. 그릴건데 뭘 가지고 그리냐 ? user라는 프로퍼티리스트 -> 뭐 이것저것 많음
// likes: [id: bool]
// 2. likes를 가져다가 데이터소스로 박아야한다. how?
// 3.
// 4. 누른다면, cell을 그리는ㄱ데 기준이되는 딕셔너리가 변경되어야하나? ㅍ로퍼티 리스트도 변경해야함
// 바뀌고 나서 한번 여기가다 채워야하
// index랑
// cell에 들어있는 정보는 위 함수에서 indexpath.row 접근할 수 밖에 없지않나요?
// cell에서 하트를 누르면 tableview[indexpath.row]의 하트가 눌린거죠
// 그거랑 프로퍼티리스트에서 가져오는 likes랑 어떻게 연결하죠..
