//
//  StarsSearchViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/15.
//

import UIKit
import XLPagerTabStrip

class StarsSearchViewController: UIViewController, IndicatorInfoProvider {
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "인기키워드")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
}
