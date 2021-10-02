//
//  StarsSearchViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/15.
//

import UIKit

class StarsSearchViewController: UIViewController, StoryboardInstantiable {
  
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
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  deinit {
    print(#function)
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
}
