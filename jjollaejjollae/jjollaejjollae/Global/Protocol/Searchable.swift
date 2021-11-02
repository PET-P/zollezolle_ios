//
//  Searchable.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/16.
//

import UIKit

protocol SearchDataReceiveable: NSObject {
  var newDataList: [SearchResultData] {get set}
  func gotoSearchVC(from caller: UIViewController)
  func returnHeart(placeId: String)
}

extension SearchDataReceiveable {
  func gotoSearchVC(from caller: UIViewController) {
    caller.navigationController?.popViewController(animated: true)
    caller.tabBarController?.tabBar.isHidden = false
  }
}

protocol Searchable: NSObject {
  func sendRightVC(from viewController: UIViewController, by region: String, regionCount : Int, with result: [SearchResultData]) -> UIViewController
}

extension Searchable {
  
  func sendRightVC(from viewController: UIViewController, by region: String, regionCount: Int, with result: [SearchResultData]) -> UIViewController {
    let afterTrimText = region.trimmingCharacters(in: .whitespacesAndNewlines)
    let locationlist = LocationName.allCases.map({$0.description})
    let categoryList = CategoryType.allCases.map({$0.rawValue})
    
    //결과X, region도 없을때
    if result.count == 0 && !locationlist.contains(afterTrimText.components(separatedBy: " ")[0]) && !categoryList.contains(SearchManager.shared.searchText) {
      guard let noSearchVC = SearchNoResultViewController.loadFromStoryboard() as? SearchNoResultViewController else {return SearchNoResultViewController()}
      return noSearchVC
    } else {
      switch afterTrimText {
        
      // 리전 존재
      case LocationName.jeju.description, LocationName.gyeongju.description,
        LocationName.daegu.description, LocationName.gangneung.description,
        LocationName.seoul.description, LocationName.sokcho.description,
        LocationName.yeosu.description:
        guard let searchLocationVC = SearchWithLocationViewController.loadFromStoryboard()
                as? SearchWithLocationViewController else {return SearchWithLocationViewController()}
        searchLocationVC.setRegion(region: region)
        searchLocationVC.setLocationNum(regionCount: regionCount)
        return searchLocationVC
        //그 외의 것들은 searchResultVC에서 분기를 나눈다.
      default:
        guard let searchResultVC = SearchResultViewController.loadFromStoryboard()
                as? SearchResultViewController else {return SearchResultViewController()}
        searchResultVC.setMode(from: viewController)
        return searchResultVC
      }
    }
  }
}



