//
//  MyInfoReservationViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/06.
//

import UIKit

class MyInfoReservationViewController: UIViewController, StoryboardInstantiable {
  @IBOutlet weak var noticeLabel: UILabel! {
    didSet {
      noticeLabel.textColor = .gray03
    }
  }
  @IBOutlet weak var goSearchButton: UIButton! {
    didSet {
      
      goSearchButton.setTitleColor(.themeGreen, for: .normal)
      goSearchButton.setTitleColor(.themeGreen, for: .selected)
      goSearchButton.titleLabel?.font = .robotoMedium(size: 14)
    }
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  @IBAction func didTapgoSearchButton(_ sender: Any) {
    guard let searchVC = SearchViewController.loadFromStoryboard() as? SearchViewController else {return}
    self.navigationController?.pushViewController(searchVC, animated: true)
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
}
