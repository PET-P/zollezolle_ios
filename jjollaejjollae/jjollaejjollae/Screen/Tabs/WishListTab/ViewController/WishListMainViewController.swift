//
//  WishListMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class WishListMainViewController: UIViewController {
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
      super.viewDidLoad()
  }
}


// MARK: - Storyboard

extension WishListMainViewController: Storyboardable {
  
  static func loadFromStoryboard(fileName: String) -> UIViewController {
    
    let identifier = "\(fileName)ViewController"
    
    let storyboard = UIStoryboard(name: fileName, bundle: nil)
    
    let wishListMainVC = storyboard.instantiateViewController(identifier: identifier)
    
    return wishListMainVC
  }
}
