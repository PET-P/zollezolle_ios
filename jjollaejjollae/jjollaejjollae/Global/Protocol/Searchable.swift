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
    caller.navigationController?.popViewController(animated: true)
  }
}

protocol Searchable: NSObject {
  func sendRightVC(from viewController: UIViewController, by text: String, with result: [SearchResultData]) -> UIViewController
}

extension Searchable {
  
  func sendRightVC(from viewController: UIViewController, by text: String, with result: [SearchResultData]) -> UIViewController {
    let afterTrimText = text.trimmingCharacters(in: .whitespacesAndNewlines)
    if result.count == 0 {
      //TODO: 위치모드를 나눠야할 것 같다.
      guard let noSearchVC = SearchNoResultViewController.loadFromStoryboard() as? SearchNoResultViewController else {return SearchNoResultViewController()}
      return noSearchVC
    } else {
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
        searchResultVC.setMode(from: viewController)
        return searchResultVC
      }
    }
  }
}



