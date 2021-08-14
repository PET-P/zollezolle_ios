//
//  RecentSearchViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/14.
//

import UIKit
import XLPagerTabStrip

class RecentSearchViewController: UIViewController, IndicatorInfoProvider {

  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "최근 검색어")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  
}
