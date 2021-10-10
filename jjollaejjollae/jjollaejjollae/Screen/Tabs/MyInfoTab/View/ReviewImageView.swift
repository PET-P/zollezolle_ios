//
//  ReviewImageView.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import UIKit
import SwiftUI

class ReviewImageView: UIView {
  private var imageArray: [UIImageView]!
  private var myImageView: UIImageView!
  private var verticalStackView: UIStackView?
  private var topHorizontalStackView: UIStackView?
  private var bottomHorizontalStackView: UIStackView?
  private var imageData: [Data]?
  private var defaultImageData = UIImage(named: "IMG_4930")?.jpegData(compressionQuality: 0.1)
  private var imageNumber = 1
  private let gap: CGFloat = 6
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(frame: CGRect, numberOfImage: Int) {
    self.init(frame: frame)
    switch numberOfImage {
    case 1:
      OneImageInit(frame: frame)
    case 2:
      TwoImageInit(frame: frame)
    case 3:
      ThirdImageInit(frame: frame)
    case 4:
      FourthImageInit(frame: frame)
    default:
      OneImageInit(frame: frame)
    }
  }
  
  required init(coder: NSCoder){
    super.init(coder: coder)!
  }
  
  override class func awakeFromNib() {
    super.awakeFromNib()
    print(#function)
  }

  func setImageData(data: [Data], imageNumber: Int) {
    imageData = data
    self.imageNumber = imageNumber
  }

  private func OneImageInit(frame: CGRect) {
    print(#function)
    let imageviewHeight: CGFloat = 343
    myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: imageviewHeight))
//    guard let imageData = imageData?.first else {
//      return
//    }
    myImageView.image = UIImage(data: defaultImageData!)
    setupImage(imageView: myImageView)
    self.addSubview(myImageView)
    myImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    myImageView.heightAnchor.constraint(equalToConstant: imageviewHeight).isActive = true
    myImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
  }
  
  private func TwoImageInit(frame: CGRect) {
    let imageViewHeight = frame.height
    myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: (imageViewHeight - gap) / 2))
    let imageview2 = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: (imageViewHeight - gap) / 2))
    imageArray = [myImageView, imageview2]
    for index in imageArray.indices {
      imageArray[index].image = UIImage(data: (imageData?[index] ?? defaultImageData)!)
     setupImage(imageView: imageArray[index])
    }
    let stackView = UIStackView(arrangedSubviews: imageArray)
    setupStackView(stackView, axis: .vertical)
    self.addSubview(stackView)
    stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    verticalStackView = stackView
  }
  
  
  
  private func ThirdImageInit(frame: CGRect) {
    print(#function)
    let imageViewHeight = frame.height
    let imageViewWidth = frame.width
    myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageViewWidth, height: (imageViewHeight - gap) / 2))
    let imageview2 = UIImageView(frame: CGRect(x: 0, y: 0, width: (imageViewWidth - gap) / 2, height: (imageViewHeight - gap) / 2))
    let imageview3 = UIImageView(frame: CGRect(x: 0, y: 0, width: (imageViewWidth - gap) / 2, height: (imageViewHeight - gap) / 2))
    imageArray = [myImageView, imageview2, imageview3]
    for index in imageArray.indices {
      imageArray[index].image = UIImage(data: (imageData?[index] ?? defaultImageData)!)
      setupImage(imageView: imageArray[index])
    }
    let horizontalStackView = UIStackView(arrangedSubviews: [imageArray[1], imageArray[2]])
    setupStackView(horizontalStackView, axis: .horizontal)
    let verticalStackView = UIStackView(arrangedSubviews: [imageArray[0], horizontalStackView])
    setupStackView(verticalStackView, axis: .vertical)
    self.addSubview(verticalStackView)
    verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    verticalStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    self.verticalStackView = verticalStackView
    self.topHorizontalStackView = horizontalStackView
  }
  
  private func FourthImageInit(frame: CGRect) {
    let imageViewHeight = frame.height
    let imageViewWidth = frame.width
    myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: (imageViewWidth - gap) / 2, height: (imageViewHeight - gap) / 2))
    let imageview2 = UIImageView(frame: CGRect(x: 0, y: 0, width: (imageViewWidth - gap) / 2, height: (imageViewHeight - gap) / 2))
    let imageview3 = UIImageView(frame: CGRect(x: 0, y: 0, width: (imageViewWidth - gap) / 2, height: (imageViewHeight - gap) / 2))
    let imageview4 = UIImageView(frame: CGRect(x: 0, y: 0, width: (imageViewWidth - gap) / 2, height: (imageViewHeight - gap) / 2))
    imageArray = [myImageView, imageview2, imageview3, imageview4]
    for index in imageArray.indices {
      imageArray[index].image = UIImage(data: (imageData?[index] ?? defaultImageData)!)
      setupImage(imageView: imageArray[index])
    }
    let horizontalStackView1 = UIStackView(arrangedSubviews: [imageArray[0], imageArray[1]])
    setupStackView(horizontalStackView1, axis: .horizontal)
    let horizontalStackView2 = UIStackView(arrangedSubviews: [imageArray[2], imageArray[3]])
    setupStackView(horizontalStackView2, axis: .horizontal)
    let verticalStackView = UIStackView(arrangedSubviews: [horizontalStackView1, horizontalStackView2])
    setupStackView(verticalStackView, axis: .vertical)
    self.addSubview(verticalStackView)
    verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    verticalStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    self.verticalStackView = verticalStackView
    self.topHorizontalStackView = horizontalStackView1
    self.bottomHorizontalStackView = horizontalStackView2
  }
  

  private func setupStackView(_ stackView: UIStackView, axis: NSLayoutConstraint.Axis) {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = axis
    stackView.spacing = gap
    stackView.distribution = .fillEqually
  }
  
  private func setupImage(imageView: UIImageView) {
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 10
    imageView.translatesAutoresizingMaskIntoConstraints = false
  }
}



