//
//  ProvisionViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/07.
//

import UIKit

class ProvisionViewController: UIViewController, StoryboardInstantiable {
  
  private var mode = 0
  
  internal func getMode(mode: Provisions) {
    self.mode = mode.rawValue
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.text = self.mode.description
  }
  
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.textColor = .gray01
      titleLabel.font = .robotoMedium(size: 16)
    }
  }
  
  @IBAction func didTapXButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
}
