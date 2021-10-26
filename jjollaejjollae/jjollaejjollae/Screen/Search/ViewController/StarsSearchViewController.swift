//
//  StarsSearchViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/15.
//

import UIKit

class StarsSearchViewController: UIViewController, StoryboardInstantiable, Searchable {
  
  @IBOutlet weak var starTableView: UITableView! {
    didSet {
      starTableView.separatorStyle = .none
      starTableView.separatorColor = .clear
    }
  }
  
  private lazy var searchManager = SearchManager.shared
  private var list = [String]()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    starTableView.delegate = self
    starTableView.dataSource = self
    list = searchManager.retrieveStarSearchArray()
  }
  
}

extension StarsSearchViewController: UITableViewDelegate {
  
}

extension StarsSearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "starCell",
                                                                        for: indexPath)
            as? SearchTableViewCell else {return UITableViewCell()}
    cell.recommendLabel.text = list[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let text =  list[indexPath.row]
    SearchManager.shared.searchText = text
    if let token = UserManager.shared.userIdandToken?.token {
      APIService.shared.search(token: token, keyword: text, page: 0) { result in
        switch result{
        case .success(let data):
          guard let nextVC = self.sendRightVC(from: self, by: data.region, with: data.result) as? UIViewController&SearchDataReceiveable else {return}
          if data.result.count != 0 {nextVC.newDataList = data.result}
          self.navigationController?.pushViewController(nextVC, animated: true)
        case .failure(let error):
          print("error: ",error)
        }
      }
    } else {
      APIService.shared.search(keyword: text, page: 0) { (result) in
        switch result {
        case .success(let data):
          guard let nextVC = self.sendRightVC(from: self, by: data.region, with: data.result) as? UIViewController&SearchDataReceiveable else {return}
          if data.result.count != 0 {nextVC.newDataList = data.result}
          self.navigationController?.pushViewController(nextVC, animated: true)
        case .failure(let error):
          print(self, #function, error)
        }
      }
    }
  }
}
