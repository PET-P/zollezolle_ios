//
//  AllReviewsTableViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/13.
//

import UIKit

class AllReviewsTableViewController: UITableViewController, StoryboardInstantiable {

    override func viewDidLoad() {
      super.viewDidLoad()
    }

    // MARK: - Table view data source
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
}


// MARK: - UITableViewDelegate
extension AllReviewsTableViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "AllReviewsTableViewCell") as? AllReviewsTableViewCell ?? AllReviewsTableViewCell()
    
    return cell
  }
}


