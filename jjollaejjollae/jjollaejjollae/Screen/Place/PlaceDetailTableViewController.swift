//
//  PlaceDetailTableViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/27.
//

import UIKit
import Moya
import SwiftyJSON

class PlaceDetailTableViewController: UITableViewController, StoryboardInstantiable {
  
  /**
   이전 화면에서 전달? 아니면 직접 네트워크 통신으로 불러옴?
   */
  var placeInfo: PlaceInfo?
  
  @IBOutlet weak var titleLabel: UILabel!
  
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
