//
//  ProvisionViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/07.
//

import UIKit

class ProvisionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
