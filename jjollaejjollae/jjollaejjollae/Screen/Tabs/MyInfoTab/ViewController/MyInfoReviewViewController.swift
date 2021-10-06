//
//  MyInfoReviewViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/06.
//

import UIKit

class MyInfoReviewViewController: UIViewController, StoryboardInstantiable {
  
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.textColor = .gray03
    }
  }
  
  @IBOutlet var subtitle: [UILabel]! {
    didSet {
      subtitle.forEach { (sub) in
        sub.textColor = .gray03
      }
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }

  

}
