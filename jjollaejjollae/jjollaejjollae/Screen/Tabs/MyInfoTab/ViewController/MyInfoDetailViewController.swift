//
//  MyInfoDetailViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/03.
//

import UIKit

class MyInfoDetailViewController: UIViewController, StoryboardInstantiable{
  
  @IBOutlet weak var infoSegmentedControl: UISegmentedControl! {
    didSet {
      infoSegmentedControl.removeBorder()
      infoSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.themeGreen, NSAttributedString.Key.font: UIFont.robotoBold(size: 16)], for: .selected)
      infoSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray03, NSAttributedString.Key.font : UIFont.robotoMedium(size: 16)], for: .normal)
      infoSegmentedControl.addBorder([.bottom], color: .gray05, width: 1)
    }
  }
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  private var userInfo: UserData?
  private var representDogImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(getpageIndex(_:)),
                                           name: NSNotification.Name("SegControlNotification"),
                                           object: nil)
    PagingManager.shared.mainVC = self
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    userInfo = UserManager.shared.userInfo

  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
}
//MARK: - IBACTION & OBJC

extension MyInfoDetailViewController {
  
  @objc func getpageIndex(_ notification: Notification) {
    var getValue = notification.object as! Int
    print(getValue)
    if getValue < 0 {
      getValue = 0
    } else if getValue >= 2 {
      getValue = 1
    }
    infoSegmentedControl.selectedSegmentIndex = getValue
  }
  
  @IBAction func didTapInfoSegmentedControl(_ sender: UISegmentedControl) {
    //여기도 노티를 보내긴해야함
    NotificationCenter.default.post(name: NSNotification.Name("PageControlNotification"), object: infoSegmentedControl.selectedSegmentIndex)
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}



