//
//  FixModalViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/26.
//

import UIKit

class FixModalViewController: UIViewController, StoryboardInstantiable {
  
  override func viewDidLoad() {
    self.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 10);
  }
}
