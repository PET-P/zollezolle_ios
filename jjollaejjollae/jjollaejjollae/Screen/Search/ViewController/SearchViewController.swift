//
//  SearchViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/14.
//

import UIKit
import XLPagerTabStrip


class SearchViewController: ButtonBarPagerTabStripViewController  {
  
  var menuStr: String = ""
  @IBOutlet weak var starTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    starTableView.delegate = self
//    starTableView.dataSource = self
    setUpButton()
  }
  
  private func setUpButton() {
    settings.style.buttonBarBackgroundColor = .색e8
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.buttonBarItemFont = .robotoBold(size: 14)
    settings.style.selectedBarBackgroundColor = .쫄래페일그린
    settings.style.buttonBarItemTitleColor = .쥐색38
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0
    settings.style.buttonBarItemsShouldFillAvailableWidth = true
    settings.style.buttonBarHeight = 2.0
    
    changeCurrentIndexProgressive = {
      (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage:
      CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = .쥐색38
      newCell?.label.textColor = .쫄래페일그린
    }
  }
  
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController)
  -> [UIViewController] {
    let searchStoryboard = UIStoryboard(name: "Search", bundle: nil)
    guard let recentVC = searchStoryboard
            .instantiateViewController(withIdentifier: "RecentSearchViewController")
            as? RecentSearchViewController else {return []}
    let starStoryboard = UIStoryboard(name: "Stars", bundle: nil)
    guard let starVC = starStoryboard
            .instantiateViewController(withIdentifier: "StarsSearchViewController")
            as? StarsSearchViewController else {return []}
//    searchVC.menuStr = "인기키워드"
//    recentVC.menuStr = "최근 검색어"
    return [starVC, recentVC]
  }
  
  
}
//
//extension SearchViewController: UITableViewDelegate {
//
//}
//
//extension SearchViewController: UITableViewDataSource {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    0
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    return UITableViewCell()
//  }
//
//
//}
