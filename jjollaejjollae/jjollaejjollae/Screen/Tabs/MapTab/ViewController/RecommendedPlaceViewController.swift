//
//  RecommendedPlaceViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/09/20.
//

import UIKit

class RecommendedPlaceViewController: UIViewController {
  
  /**
   FIXME: mapMainVC 와의 연결성이 필요하지 않아보임
   */
  
  weak var mapMainVC: MapMainViewController!
  
  
  var nearPlaceList: [SearchResultData]? {
    
    didSet {
      guard let placeTableView = placeTableView else { return }
      
      placeTableView.reloadData()
    }
  }
    
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
  
  @IBOutlet weak var placeTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpPlaceTableView()
  }
  
  private func setUpPlaceTableView() {
    
    placeTableView.dataSource = self
    placeTableView.delegate = self
    
    placeTableView.isUserInteractionEnabled = false
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
          placeTableView.isUserInteractionEnabled = true
          
        } else {
          mapMainVC.setInitialContainerViewHeight()
          placeTableView.contentOffset = CGPoint(x: 0.0, y: 0.0)
          placeTableView.isUserInteractionEnabled = false
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

    placeTableView.isUserInteractionEnabled = false
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    beganPhaseInitialHeight = mapMainVC?.containerView.frame.height
  }
}

extension RecommendedPlaceViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return nearPlaceList?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.identifier, for: indexPath) as? PlaceTableViewCell else { return UITableViewCell () }
    
    guard let data = nearPlaceList?[indexPath.row] else { return UITableViewCell () }
    
    if let partialImageURL = data.imagesUrl.first {
      cell.mainImageView.setImage(with: partialImageURL)
    }
    cell.placeTitle = data.title
    cell.category = data.category.rawValue
    cell.reviewPoint = data.reviewPoint ?? 0.0
    cell.reviewCount = data.reviewCount
    
    return cell
  }
  
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let yOffset = scrollView.contentOffset.y
    
//    if yOffset < 0 {
//
//      mapMainVC.setInitialContainerViewHeight()
//      placeTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//      placeTableView.isUserInteractionEnabled = false
//    }
  }
}

extension RecommendedPlaceViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let placeId = nearPlaceList?[indexPath.row].id else { return }
    
    APIService.shared.fetchPlaceInfo(placeId: placeId) { result in
      
      switch result {
        case .success(let data):

          guard let vc = PlaceDetailTableViewController.loadFromStoryboard() as? PlaceDetailTableViewController else { return }
          
          let placeInfo = PlaceInfo.init(placeID: placeId, data: data)
          
          vc.placeInfo = placeInfo
          
          self.navigationController?.pushViewController(vc, animated: true)
          
        case .failure(let statusCode):
          print(statusCode)
      }
    }
    
  }
}
