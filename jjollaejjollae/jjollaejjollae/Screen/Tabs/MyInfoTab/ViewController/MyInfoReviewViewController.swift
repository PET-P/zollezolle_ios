//
//  MyInfoReviewViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/06.
//

import UIKit

class MyInfoReviewViewController: UIViewController, StoryboardInstantiable {
  
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.textColor = .gray03
      titleLabel.isHidden = true
    }
  }
  
  @IBOutlet var subtitle: [UILabel]! {
    didSet {
      subtitle.forEach { (sub) in
        sub.textColor = .gray03
        sub.isHidden = true
      }
    }
  }
  @IBOutlet weak var reviewTableView: UITableView! {
    didSet {
      reviewTableView.delegate = self
      reviewTableView.dataSource = self
    }
  }
  @IBOutlet weak var headerView: UIView!
 
  @IBOutlet weak var navLabel: UILabel! {
    didSet {
      navLabel.font = .robotoBold(size: 20)
      navLabel.textColor = .gray01
    }
  }
  @IBOutlet weak var reviewNumLabel: UILabel! {
    didSet {
      reviewNumLabel.text = "총 17개의 후기"
      reviewNumLabel.textColor = .gray01
      reviewNumLabel.font = .robotoBold(size: 18)
    }
  }
  
  @IBOutlet weak var helpNumLabel: UILabel! {
    didSet {
      helpNumLabel.text = "31개의 도움돼요"
      helpNumLabel.textColor = .gray03
      helpNumLabel.font = .robotoBold(size: 11)
    }
  }
  
  private var reviewNumber: Int = 0 {
    didSet {
      reviewNumLabel.text = "총 \(reviewNumber)개의 후기"
    }
  }
  
  private var helpNumber: Int = 0 {
    didSet {
      helpNumLabel.text = "\(helpNumber)개의 도움돼요"
    }
  }
  @IBOutlet weak var separateLine: UIView! {
    didSet {
      separateLine.backgroundColor = .gray06
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reviewTableView.register(UINib(nibName: ReviewTableCell.nibName, bundle: nil), forCellReuseIdentifier: "reviewCell")
    
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}

extension MyInfoReviewViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath)
    return cell
  }
  

  
  
}
