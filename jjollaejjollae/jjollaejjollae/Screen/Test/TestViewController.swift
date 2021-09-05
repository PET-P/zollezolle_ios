//
//  TestViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/20.
//

import UIKit

class TestViewController: UIViewController {

  @IBOutlet weak var testLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    let robotoFont = UIFont.robotoBold(size: 12)
//    testLabel.font = UIFontMetrics.default.scaledFont(for: robotoFont)
//    testLabel.adjustsFontForContentSizeCategory = true
    
    navigationItem.backButtonTitle = ""
  }
  
  @IBAction func didTapButton(_ sender: Any) {
    
    let detailAccomodationVC = DetailAccomodationsViewController.loadFromStoryboard()
    self.navigationController?.pushViewController(detailAccomodationVC, animated: true)
  }
}

extension TestViewController: Storyboardable { }
