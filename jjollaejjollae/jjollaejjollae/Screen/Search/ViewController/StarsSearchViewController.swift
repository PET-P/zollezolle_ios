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
    // 혹시나 있을 양 옆 공백을 없애기 위한 작업
    if let token = LoginManager.shared.loadFromKeychain(account: "accessToken") {
      APIService.shared.search(token: token, keyword: text) { result in
        switch result{
        case .success(let data):
          guard let nextVC = self.sendRightVC(by: data.region, with: data.result) as? UIViewController&SearchDataReceiveable else {return}
          nextVC.newDataList = data.result
          self.navigationController?.pushViewController(nextVC, animated: true)
        case .failure(let error):
          print(self, #function, error)
        }
      }
    } else {
      APIService.shared.search(keyword: text) { (result) in
        switch result {
        case .success(let data):
          guard let nextVC = self.sendRightVC(by: data.region, with: data.result) as? UIViewController&SearchDataReceiveable else {return}
          nextVC.newDataList = data.result
          self.navigationController?.pushViewController(nextVC, animated: true)
        case .failure(let error):
          print(self, #function, error)
        }
      }
    }
  }
}
