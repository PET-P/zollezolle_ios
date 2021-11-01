//
//  RecentSearchViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/14.
//

import UIKit

class RecentSearchViewController: UIViewController, StoryboardInstantiable, Searchable {
  
  private lazy var searchManager = SearchManager.shared
  private var list = [String]()
  
  @IBOutlet weak var recentTableView: UITableView! {
    didSet {
      recentTableView.separatorStyle = .none
      recentTableView.separatorColor = .clear
    }
  }

  override func viewDidLoad() {
    recentTableView.delegate = self
    recentTableView.dataSource = self
    super.viewDidLoad()
    list = searchManager.retrieveSearchHistory()
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateList(_:)),
                                           name: Notification.Name("updateListNotification"),
                                           object: nil)
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
    guard let cell: SearchTableViewCell =
            tableView.dequeueReusableCell(withIdentifier: "recentCell",
                                          for: indexPath) as? SearchTableViewCell
    else {return UITableViewCell()}
    cell.recommendLabel.text = list[indexPath.row]
    return cell
  }
}

extension RecentSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCell.EditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      list.remove(at: indexPath.row)
      searchManager.updateSearchHistory(with: list)
      recentTableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {}
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //서버로 바로 이동하면서
    //text값 가지고 다른화면으로 이동하기
    let text =  list[indexPath.row]
    SearchManager.shared.searchText = text
    if let token = UserManager.shared.userIdandToken?.token {
      LoadingIndicator.show()
      APIService.shared.search(token: token, keyword: text, page: 0) { result in
        switch result{
        case .success(let data):
          guard let nextVC = self.sendRightVC(from: self, by: data.region, regionCount: data.regionCount, with: data.result) as? UIViewController&SearchDataReceiveable else {return}
          if data.result.count != 0 {nextVC.newDataList = data.result}
          self.navigationController?.pushViewController(nextVC, animated: true) {
            LoadingIndicator.hide()
          }
        case .failure(let error):
          print("error: ",error)
          LoadingIndicator.hide()
        }
      }
    } else {
      LoadingIndicator.show()
      APIService.shared.search(keyword: text, page: 0) { (result) in
        switch result {
        case .success(let data):
          guard let nextVC = self.sendRightVC(from: self, by: data.region, regionCount: data.regionCount, with: data.result) as? UIViewController&SearchDataReceiveable else {return}
          if data.result.count != 0 {nextVC.newDataList = data.result}
          self.navigationController?.pushViewController(nextVC, animated: true) {
            LoadingIndicator.hide()
          }
        case .failure(let error):
          print(self, #function, error)
          LoadingIndicator.hide()
        }
      }
    }
  
  }
  
}
