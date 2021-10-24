//
//  SearchWithLocationViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/26.
//

import UIKit

class SearchWithLocationViewController: UIViewController, StoryboardInstantiable, UITextFieldDelegate, Searchable, SearchDataReceiveable {
  
  var newDataList: [SearchResultData] = [] {
    didSet {
      newDataList.forEach { (data) in
        likes.updateValue(data.isWish ?? false, forKey: data.id)
      }
    }
  }
  
  @IBOutlet weak var SearchResultTableView: UITableView!
  
  let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
  private var dataList = [SearchResultInfo]()
  private var searchData = [String]()
  lazy var likes: [String : Bool] = [:]
  
  @IBOutlet weak var headView: UIView! {
    didSet {
      headView.backgroundColor = .themePaleGreen
    }
  }
  @IBOutlet weak var searchTextField: UITextField! {
    didSet {
      searchTextField.setRounded(radius: nil)
      //get
      searchTextField.text = SearchManager.shared.searchText
      searchTextField.delegate = self
    }
  }
  @IBOutlet weak var backButton: UIView!
  @IBOutlet weak var headerLabel: UILabel! {
    didSet {
      headerLabel.font = .robotoBold(size: 18)
      headerLabel.textColor = .gray02
    }
  }
  @IBOutlet weak var separateLine: UIView! {
    didSet {
      separateLine.backgroundColor = .gray06
    }
  }
  @IBOutlet weak var LocationView: UIImageView! {
    didSet {
      LocationView.image = UIImage(named: "\(SearchManager.shared.searchText)2")
      LocationView.setRounded(radius: 10)
    }
  }
  
  @IBOutlet weak var locationLabel: UILabel! {
    didSet {
      locationLabel.text = SearchManager.shared.searchText
      locationLabel.textColor = .white
      locationLabel.font = .robotoBold(size: 18)
    }
  }
  @IBOutlet weak var locationNumLabel: UILabel! {
    didSet {
      locationNumLabel.text = "178개의 장소"
      locationNumLabel.textColor = .white
      locationNumLabel.font = .robotoMedium(size: 12)
    }
  }
  
  private var locationNum = 10 {
    didSet {
      locationNumLabel.text = "\(locationNum)"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    SearchResultTableView.delegate = self
    SearchResultTableView.dataSource = self
    SearchResultTableView.register(nib, forCellReuseIdentifier: "resultCell")
    SearchResultTableView.isUserInteractionEnabled = true
    LocationView.isUserInteractionEnabled = true
    print("😀Test", newDataList)
    setupGesture()
  }
  
  private func setupGesture() {
    let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLocationView))
    LocationView.addGestureRecognizer(locationTapGesture)
    
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func didTapLocationView(_ sender: Any?) {
    guard let searchResultVC = SearchResultViewController.loadFromStoryboard() as? SearchResultViewController else {return}
    self.navigationController?.pushViewController(searchResultVC, animated: true)
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    gotoSearchVC(from: self)
  }
  
}

extension SearchWithLocationViewController: UITableViewDelegate, UITableViewDataSource, SearchResultCellDelegate {
  func didTapHeart(for placeId: String, like: Bool) {
    if like {
      likes[placeId] = true
    } else {
      likes[placeId] = false
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? SearchResultTableViewCell else {return UITableViewCell()}
    cell.delegate = self
    cell.placeId = newDataList[indexPath.row].id
    
    let item = newDataList[indexPath.row]
    
    cell.locationNameLabel.text = item.title
    cell.locationTypeLabel.text = nil
    cell.numberOfReviewsLabel.text = "(\(item.reviewCount))"
    cell.starPointLabel.text = " \(item.reviewPoint ?? 0)"
    
    cell.isWish = likes[cell.placeId] == true
    newDataList[indexPath.row].isWish = likes[cell.placeId] == true //이것의 이유?
    
    return cell
  }
}


