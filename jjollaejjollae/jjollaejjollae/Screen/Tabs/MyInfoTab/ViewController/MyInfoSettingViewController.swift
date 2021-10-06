//
//  MyInfoSettingViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/06.
//

import UIKit

class MyInfoSettingViewController: UIViewController, StoryboardInstantiable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  @IBAction func didTapBackButton(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
}
