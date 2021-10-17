//
//  Searchable.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/16.
//

import UIKit

protocol Searchable: NSObject {
  func gotoSearchVC(from caller: UIViewController)
  func sendRightVC(by text: String) -> UIViewController
}

extension Searchable {
  
  func gotoSearchVC(from caller: UIViewController) {
    guard let searchVC = SearchViewController.loadFromStoryboard() as? SearchViewController else {return}
    caller.navigationController?.popToViewController(searchVC, animated: true)
  }
  
  func sendRightVC(by text: String) -> UIViewController {
    let afterTrimText = text.trimmingCharacters(in: .whitespacesAndNewlines)
    SearchManager.shared.searchText = afterTrimText
    switch afterTrimText {
    case "제주", "속초", "강릉", "대구", "서울", "여수", "경주":
      guard let searchLocationVC = SearchWithLocationViewController.loadFromStoryboard() as? SearchWithLocationViewController else {return SearchWithLocationViewController()}
      return searchLocationVC
    default:
      guard let searchResultVC = SearchResultViewController.loadFromStoryboard() as? SearchResultViewController else {return SearchResultViewController()}
      return searchResultVC
    }
  }
}
