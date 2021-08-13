//
//  MyNeighborhoodMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/09.
//

import UIKit

class MyNeighborhoodMainViewController: UIViewController {
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

  }
}

extension MyNeighborhoodMainViewController: Storyboardable {
  static func loadFromStoryboard(fileName: String) -> UIViewController {
    
    let identifier = "\(fileName)ViewController"
    
    let storyboard = UIStoryboard(name: fileName, bundle: nil)
    let myNeighborhoodVC = storyboard.instantiateViewController(identifier: identifier)
    
    return myNeighborhoodVC
  }
}
