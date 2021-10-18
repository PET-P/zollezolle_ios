//
//  MapInfoView.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/30.
//

import UIKit

class InfoView: UIView {
  
  @IBOutlet weak var addressLabel: UILabel! {
    didSet {
      addressLabel.font = .robotoMedium(size: 11)
      addressLabel.textColor = .gray03
    }
  }
  @IBOutlet weak var locationNameLabel: UILabel! {
    didSet {
      addressLabel.font = .robotoBold(size: 14)
      addressLabel.textColor = .gray01
    }
  }
  @IBOutlet weak var starPointLabel: UILabel! {
    didSet {
      starPointLabel.font = .robotoBold(size: 12)
      starPointLabel.textColor = .gray03
    }
  }
  @IBOutlet weak var numberOfReviewLabel: UILabel! {
    didSet {
      numberOfReviewLabel.textColor = .gray03
      numberOfReviewLabel.font = .robotoRegular(size: 10)
    }
  }
  @IBOutlet weak var locationImageView: UIImageView!
  @IBOutlet weak var heartButton: UIButton!
  private var CallerVC: UIViewController?
  internal func setCallerVC(viewController: UIViewController) {
    CallerVC = viewController
  }
  
  var isWish: Bool? {
    didSet {
      if isWish == true {
        heartButton.setImage(UIImage(named: "pinkLike"), for: .normal)
      } else {
        heartButton.setImage(UIImage(named: "grayLike"), for: .normal)
      }
    }
  }
  
  override var isHidden: Bool {
    didSet {
      if isHidden {
        //data 보내기
        heartButton?.isSelected = false
      }
    }
  }
  
  var data: SearchResultInfo? = nil {
    didSet {
      addressLabel.text = data?.location
      locationNameLabel.text = data?.name
      starPointLabel.text = "\(data?.points ?? 0)"
      numberOfReviewLabel.text = "\(data?.numbers ?? 0)"
      locationImageView.image = UIImage(named: "IMG_4930")
      if data?.like == true{
        heartButton.setImage(UIImage(named: "pinkLike"), for: .normal)
      } else {
        heartButton.setImage(UIImage(named: "grayLike"), for: .normal)
      }
    }
  }
  @IBAction func didTapHearButton(_ sender: UIButton) {
    //여기서 db와통신? 해야하는지?
    if sender.isSelected == true {
      isWish = false
    } else  {
      isWish = true
      guard let wishListMainVC = WishlistMainViewController.loadFromStoryboard() as? WishlistMainViewController else {
        return
      }
      CallerVC?.present(wishListMainVC, animated: true, completion: nil)
    }
    sender.isSelected = !sender.isSelected
    print("iswish: ", isWish, "sender.isselected: ", sender.isSelected)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUpView()
  }
  
  private func setUpView() {
    let nib = UINib(nibName: "InfoView", bundle: Bundle.main)
    guard let infoView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {return}
    addressLabel.sizeToFit()
    infoView.frame = self.bounds
    infoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(infoView)
    infoView.backgroundColor = .white
  }
}
