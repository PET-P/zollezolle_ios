//
//  RecommendedPlaceViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/09/20.
//

import UIKit

class RecommendedPlaceViewController: UIViewController {
  
  var mapMainVC: MapMainViewController!
    
  private var beganPhaseInitialHeight: CGFloat!
  
  private var containerView: UIView {
    get {
      mapMainVC.containerView
    }
  }
  
  private var containerViewOriginalHeight: CGFloat {
    get {
      mapMainVC.containerViewOriginalHeight
    }
  }
  
  @IBOutlet weak var panIndicator: UIView! = nil {
    didSet {
      panIndicator.layer.cornerRadius = panIndicator.frame.height / 2
    }
  }
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTableView()
    
    view.layer.cornerRadius = 19
  }
  
  private func setUpTableView() {
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.isUserInteractionEnabled = false
  }
  
  private var previousYPoint: CGFloat = 0.0
  private var previousUpward: Bool = false
  
  @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
    
    let currentYPoint = sender.translation(in: sender.view).y
    
    var isUpward = previousUpward
    
    if sender.state == .ended {
      
      let currentHeight = containerView.frame.height
      let initialHeight = mapMainVC.containerViewOriginalHeight
      
      // 현재 컨테이너뷰 높이가 초기 높이 초과일 때
      if currentHeight > initialHeight {
        
        if isUpward {
          mapMainVC.setMaximumContainerViewHeight()
          tableView.isUserInteractionEnabled = true
          
        } else {
          mapMainVC.setInitialContainerViewHeight()
          tableView.isUserInteractionEnabled = false
        }
        // 현재 컨테이너뷰 높이가  초기 높이 미만일 때
      } else if currentHeight < initialHeight {
        
        if isUpward {
          mapMainVC.setInitialContainerViewHeight()
        } else {
          mapMainVC.setZeroContainerViewHeight()
        }
      }
      
      previousYPoint = CGFloat.zero
      return
    }

    isUpward = previousYPoint >  currentYPoint ? true : false

    previousYPoint = currentYPoint
    previousUpward = isUpward
    
    let addingHeightValue = -(currentYPoint)

    let constant = beganPhaseInitialHeight + addingHeightValue

    mapMainVC?.setTemporalContainerViewHeight(with: constant)

    tableView.isUserInteractionEnabled = false
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    beganPhaseInitialHeight = mapMainVC?.containerView.frame.height
  }
}

extension RecommendedPlaceViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
    
    return cell
  }
  
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let yOffset = scrollView.contentOffset.y
    
    if yOffset < 0 {
      
      mapMainVC.setInitialContainerViewHeight()
      tableView.isUserInteractionEnabled = false
    }
  }
}

extension RecommendedPlaceViewController: UITableViewDelegate {
  
}
