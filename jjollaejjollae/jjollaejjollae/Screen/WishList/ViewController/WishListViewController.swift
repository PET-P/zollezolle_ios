//
//  WishListViewController.swift
//  jjollaejjollae
//


import UIKit

class WishListViewController: UIViewController {
  
  //MARK: - IBOUTLET
  @IBOutlet weak var wishListTitle: UILabel! {
    didSet {
      wishListTitle.font = .robotoBold(size: 24)
      wishListTitle.textColor = .gray01
    }
  }

  @IBOutlet weak var locationAndDateLabel: UILabel! {
    didSet {
      locationAndDateLabel.font = .robotoMedium(size: 13)
      locationAndDateLabel.textColor = .gray01
    }
  }
  
  @IBOutlet weak var wishListCountLabel: UILabel! {
    didSet {
      wishListCountLabel.font = .robotoMedium(size: 12)
      wishListCountLabel.textColor = .gray01
    }
  }
  
  private var dataList: [SearchResultInfo] = []
  private var likes: [Int: Bool] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  
  //MARK: - IBACTION

  @IBAction private func didTapBackButton(_ sender: UIButton) {
    
  }
  
  @IBAction private func didTapOptionButton(_ sender: UIButton) {
    
  }
  
  
}

extension WishListViewController: UITableViewDelegate {
  //TODO: 그 장소 Detail화면으로 넘어가기
}

extension WishListViewController: UITableViewDataSource, SearchResultCellDelegate {
  func didTapHeart(for placeId: Int, like: Bool) {
    likes[placeId] = like == true ? true : false
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell else {
      return UITableViewCell()
    }
    
    cell.delegate = self
    cell.placeId = dataList[indexPath.row].id
    
    let item = dataList[indexPath.row]
    if let day = item.days, let address = item.location, let price = item.prices {
      cell.DaysLabel.isHidden = false
      cell.addressLabel.isHidden = false
      cell.priceLabel.isHidden = false
      cell.DaysLabel.text = "\(day)박 요금"
      cell.addressLabel.text = address
      cell.priceLabel.text = "\(price)원"
    } else {
      cell.addressLabel.text = nil
      cell.DaysLabel.text = nil
      cell.priceLabel.text = nil
      cell.contentStackView.removeArrangedSubview(cell.addressLabel)
    }
    
    return cell
  }
}
