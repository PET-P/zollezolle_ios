//
//  RecentSearchViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/14.
//

import UIKit
import XLPagerTabStrip

class RecentSearchViewController: UIViewController, IndicatorInfoProvider {
  
  private lazy var searchManager = SearchManager.shared
  private var list = [String]()
  
  @IBOutlet weak var recentTableView: UITableView! {
    didSet {
      recentTableView.separatorStyle = .none
      recentTableView.separatorColor = .clear
    }
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "최근 검색어")
  }
  
  
  override func viewDidLoad() {
    recentTableView.delegate = self
    recentTableView.dataSource = self
    super.viewDidLoad()
    list = searchManager.retrieveSearchHistory()
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateList(_:)), name: Notification.Name("updateListNotification"), object: nil)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    list = searchManager.retrieveSearchHistory()
    recentTableView.reloadData()
  }
  
  @objc private func updateList(_ notification: Notification) {
    list = searchManager.retrieveSearchHistory()
    print(#function)
    print(list)
    recentTableView.reloadData()
  }
}

extension RecentSearchViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
    cell.recommendLabel.text = list[indexPath.row]
    return cell
  }
}

extension RecentSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      list.remove(at: indexPath.row)
      searchManager.updateSearchHistory(with: list)
      recentTableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {}
  }
}
