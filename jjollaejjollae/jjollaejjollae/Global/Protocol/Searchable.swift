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
}

extension SearchDataReceiveable {
  func gotoSearchVC(from caller: UIViewController) {
    guard let searchVC = SearchViewController.loadFromStoryboard()
            as? SearchViewController else {return}
    caller.navigationController?.popToViewController(searchVC, animated: true)
  }
}

protocol Searchable: NSObject {
  func sendRightVC(by text: String, with result: [SearchResultData]) -> UIViewController
}

extension Searchable {
  
  func sendRightVC(by text: String, with result: [SearchResultData]) -> UIViewController {
    let afterTrimText = text.trimmingCharacters(in: .whitespacesAndNewlines)
    SearchManager.shared.searchText = afterTrimText
    if result.count == 0 {
      //TODO: 위치모드를 나눠야할 것 같다.
      var noResultVC: SearchNoResultViewController?
      APIService.shared.nearPlace(latitude: "127.12", longitude: "125.12") { (result) in
        switch result {
        case .success(let data):
          noResultVC = SearchNoResultViewController.loadFromStoryboard() as? SearchNoResultViewController
          guard let noResultVC = noResultVC else {
            return
          }
          noResultVC.newDataList = data
        case .failure(let error):
          print("error: \(error)")
          noResultVC = SearchNoResultViewController.loadFromStoryboard() as? SearchNoResultViewController
          guard let noResultVC = noResultVC else {
            return
          }
          noResultVC.newDataList = []
        }
      }
      guard let noResultVC = noResultVC else {
        return SearchNoResultViewController()
      }
      return noResultVC
    }
    switch afterTrimText {
    case LocationName.jeju.description, LocationName.gyeongju.description,
      LocationName.daegu.description, LocationName.gangneung.description,
      LocationName.seoul.description, LocationName.sokcho.description,
      LocationName.yeosu.description:
      guard let searchLocationVC = SearchWithLocationViewController.loadFromStoryboard()
              as? SearchWithLocationViewController else {return SearchWithLocationViewController()}
      return searchLocationVC
    default:
      guard let searchResultVC = SearchResultViewController.loadFromStoryboard()
              as? SearchResultViewController else {return SearchResultViewController()}
      return searchResultVC
    }
  }
}
