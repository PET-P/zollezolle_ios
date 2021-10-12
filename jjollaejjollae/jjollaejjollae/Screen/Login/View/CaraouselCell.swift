//
//  CollectionViewCell.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/11.
//

import UIKit

protocol CarouselCellTapDelegate {
  func didTapImageView(indexPath: IndexPath?)
}

class CaraouselCell: UICollectionViewCell {
  
  var delegate: CarouselCellTapDelegate?
  var selectedIndexPath: IndexPath?
  
  let dogImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "camera")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 50
    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.dogImageView)
    self.dogImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    self.dogImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.dogImageView.widthAnchor.constraint(equalTo: self.heightAnchor,
                                             multiplier: 0.85).isActive = true
    self.dogImageView.heightAnchor.constraint(equalTo: self.heightAnchor,
                                              multiplier: 0.85).isActive = true
    let tapGestureRecognizer = UITapGestureRecognizer(target: self,  action: #selector(self.imageTapped))
    dogImageView.addGestureRecognizer(tapGestureRecognizer)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func imageTapped() {
    self.delegate?.didTapImageView(indexPath: selectedIndexPath)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layoutIfNeeded()
    self.dogImageView.layer.cornerRadius = self.frame.height * 0.85 / 2
    self.dogImageView.layer.masksToBounds = true
    self.dogImageView.clipsToBounds = true
//    self.layer.cornerRadius =  50
    self.layer.borderColor = UIColor.clear.cgColor
    self.layer.masksToBounds = true
    self.clipsToBounds = true
  }
}
