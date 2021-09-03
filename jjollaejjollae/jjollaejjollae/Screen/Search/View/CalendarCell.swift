//
//  CalendarCellCollectionViewCell.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/03.
//

import UIKit
import FSCalendar

enum SelectionType: Int {
  case none
  case single
  case leftBorder
  case middle
  case rightBorder
}

class CalendarCell: FSCalendarCell {
  
//  weak var circleImageView: UIImageView!
  weak var selectionLayer: CAShapeLayer!
  
  var selectionType: SelectionType = .none {
    didSet {
      setNeedsLayout()
    }
  }
  
  override init!(frame: CGRect) {
    super.init(frame: frame)
//    let circleImageView = UIImageView(image: UIImage(named: "circle")!)
//    self.contentView.insertSubview(circleImageView, at: 0)
//    self.circleImageView = circleImageView
    
    let selectionLayer = CAShapeLayer()
    selectionLayer.fillColor = UIColor.쫄래페일그린.cgColor
    selectionLayer.actions = ["hidden": NSNull()]
    self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
    self.selectionLayer = selectionLayer
    
    self.shapeLayer.isHidden = true
    
    let view = UIView(frame: self.bounds)
    view.backgroundColor = UIColor.white
    self.backgroundView = view
  }
  
  required init!(coder aDecoder: NSCoder!) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    //서클뷰의 frame을 cell의 바운드와 맞추자
//    self.circleImageView.frame = self.contentView.bounds
    // backgroundview
    self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
//    self.backgroundView?.backgroundColor = UIColor.red
//    self.selectionLayer.frame = self.contentView.bounds
    self.selectionLayer.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height / 1.5)
    
    switch selectionType {
    case .middle:
      let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
      self.selectionLayer.path = UIBezierPath(rect: CGRect(x: 0, y: self.contentView.frame.height / 2 - diameter / 1.5, width: self.selectionLayer.bounds.width, height: self.selectionLayer.bounds.height)).cgPath
    case .leftBorder:
      let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
      self.selectionLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: self.contentView.frame.height / 2 - diameter / 1.5, width: self.selectionLayer.bounds.width, height: self.selectionLayer.bounds.height), byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
    case .rightBorder:
      let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
      self.selectionLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: self.contentView.frame.height / 2 - diameter / 1.5, width: self.selectionLayer.bounds.width, height: self.selectionLayer.bounds.height), byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
    case .single:
      let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
      self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 1.5, width: diameter, height: diameter)).cgPath
    case .none:
      return
    }
  }
  
  override func configureAppearance() {
    super.configureAppearance()
    if self.isPlaceholder {
      self.titleLabel.textColor = UIColor.lightGray
    }
  }
  
}
