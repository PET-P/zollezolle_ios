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
  @IBOutlet weak var heartButton: UIButton! {
    didSet {
      if UserManager.shared.userInfo == nil { heartButton.isHidden = true }
    }
  }
  private var CallerVC: UIViewController?
  private var placeId = "0"
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
  
  var data: SearchResultData? = nil {
    didSet {
      placeId = data?.id ?? "0"
      addressLabel.text = data?.address[0...2].joined(separator: " ")
      locationNameLabel.text = data?.title
      starPointLabel.text = String(format: "%.1f", data?.reviewPoint ?? 0)
      numberOfReviewLabel.text = "\(data?.reviewCount ?? 0)"
      locationImageView.setImage(with: data?.imagesUrl.first ?? "default")
      if data?.isWish == true{
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
      guard let token = UserManager.shared.userIdandToken?.token,
            let userId = UserManager.shared.userIdandToken?.userId else {return}
      APIService.shared.deletePlaceInFolder(token: token, userId: userId, folderId: nil, placeId: placeId) { result in
        switch result {
        case .success(let data):
          print(data)
        case .failure(let error):
          print(error)
        }
      }
    } else  {
      isWish = true
      guard let wishListMainVC = WishlistMainViewController.loadFromStoryboard() as? WishlistMainViewController else {
        return
      }
      wishListMainVC.setMode(mode: .fromCell)
      wishListMainVC.setPlaceInfo(placeId: placeId)
      CallerVC?.present(wishListMainVC, animated: true, completion: nil)
    }
    sender.isSelected = !sender.isSelected
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUpView()
  }
  
  convenience init?(coder: NSCoder, placeId: String) {
    self.init(coder: coder)
    self.placeId = placeId
  }
  
  convenience init(frame: CGRect, placedId: Int) {
    self.init(frame: frame)
    self.placeId = placeId
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
