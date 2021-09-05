//
//  TestNavigationController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/20.
//

// MARK: -  For Test

import UIKit

class TestNavigationController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewControllers.append(TestViewController.loadFromStoryboard())
  }
}
