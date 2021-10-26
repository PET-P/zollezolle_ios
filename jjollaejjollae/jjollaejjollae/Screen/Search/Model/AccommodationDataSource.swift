//
//  AccommodationDataSource.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/19.
//

import UIKit

class AccommodationDataSource: NSObject, UITableViewDataSource {
  var dataList: [SearchResultInfo] = []
  lazy var likes: [Int: Bool] = [:]
  private var CallerVC: UIViewController?
  internal func setCallerVC(viewController: UIViewController) {
    CallerVC = viewController
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
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //return accommoDataList.count
    return 4
  }
}

extension AccommodationDataSource: SearchResultCellDelegate {
  
  func didTapHeart(for placeId: Int, like: Bool) {
    //WISHLIST: 프로퍼티리스트를 바로바로 update시키고싶다
    if like {
      likes[placeId] = false
      //모델의 likes에 대한 Update
    } else {
      likes[placeId] = true
      guard let wishListMainVC = WishlistMainViewController.loadFromStoryboard() as? WishlistMainViewController else {
        return
      }
      CallerVC?.present(wishListMainVC, animated: true, completion: nil)
      //모델의 likes에 대한 Update
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell
    else { return UITableViewCell() }
    
    //    cell.sizeToFit()
    cell.delegate = self
    //    cell.index = indexPath.row
    cell.placeId = dataList[indexPath.row].id
    
    // index랑
    // cell에 들어있는 정보는 위 함수에서 indexpath.row 접근할 수 밖에 없지않나요?
    // cell에서 하트를 누르면 tableview[indexpath.row]의 하트가 눌린거죠
    // 그거랑 프로퍼티리스트에서 가져오는 likes랑 어떻게 연결하죠..
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
