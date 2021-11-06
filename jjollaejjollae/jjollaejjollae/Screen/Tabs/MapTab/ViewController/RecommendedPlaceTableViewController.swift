//
//  RecommendedPlaceTableViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/11/05.
//

import UIKit

class RecommendedPlaceTableViewController: UITableViewController {

  @IBOutlet weak var headerView: UIView! {
    didSet {
      headerView.layer.cornerRadius = 10
    }
  }
  override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
