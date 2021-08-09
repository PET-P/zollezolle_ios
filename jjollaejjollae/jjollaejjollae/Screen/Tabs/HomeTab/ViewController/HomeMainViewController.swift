//
//  HomeMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class HomeMainViewController: UIViewController {
	
	// MARK: - Life Cycle
  override func viewDidLoad() {
		
    super.viewDidLoad()
  }
}

// MARK: - Storyborad
extension HomeMainViewController: Storyboardable{
  
  static func loadFromStoryboard(fileName name: String) -> UIViewController {
    
    let identifier = "\(name)ViewController"
    
    let storyboard = UIStoryboard(name: name, bundle: nil)
    let homeMainVC = storyboard.instantiateViewController(identifier: identifier)
    
    return homeMainVC
  }
}
