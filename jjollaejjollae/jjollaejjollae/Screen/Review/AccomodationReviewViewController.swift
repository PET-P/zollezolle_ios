//
//  AccomodationReviewViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/08.
//

import UIKit

class AccomodationReviewViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var accomodationTitleLabel: UILabel!
  
  @IBOutlet weak var durationLabel: UILabel!
  
  @IBOutlet var starList: [UIButton]!
  
  @IBOutlet weak var withPetSatisfactionLabel: UILabel!
  
  
  
  
  var starRating: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.contentInsetAdjustmentBehavior = .never
        // Do any additional setup after loading the view.
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    
    print(#function)
    
  }
}
