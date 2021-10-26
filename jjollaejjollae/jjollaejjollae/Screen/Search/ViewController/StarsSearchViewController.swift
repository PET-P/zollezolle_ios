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
    let nextVC = sendRightVC(by: text)
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
}
