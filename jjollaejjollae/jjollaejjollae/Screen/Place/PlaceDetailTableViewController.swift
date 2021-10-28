//
//  PlaceDetailTableViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/27.
//

import UIKit
import Moya
import SwiftyJSON
import NMapsMap

class PlaceDetailTableViewController: UITableViewController, StoryboardInstantiable {
  
  /**
   이전 화면에서 전달? 아니면 직접 네트워크 통신으로 불러옴?
   */
  var placeInfo: PlaceInfo?
  
  /**
  메인
   */
  
  @IBOutlet weak var mainImageView: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var locationLabel: UILabel!  // 기본 정보에서 재사용
  
  @IBOutlet weak var ratingLabel: UILabel!
  
  /**
   시설 안내
   */
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var expandButton: UIButton!
  
  /**
   기본 정보
   */
  
  @IBOutlet weak var mapView: NMFMapView!
  
  @IBOutlet weak var phoneNumberLabel: UILabel!
  
  
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
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 500
  }
}


