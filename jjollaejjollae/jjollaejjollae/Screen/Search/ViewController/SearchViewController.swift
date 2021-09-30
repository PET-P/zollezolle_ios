//
//  SearchViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/14.
//

import UIKit

class SearchViewController: UIViewController, StoryboardInstantiable  {
  
  @IBOutlet weak var headView: UIView! {
    didSet {
      headView.backgroundColor = .themePaleGreen
    }
  }
  @IBOutlet weak var searchTextField: UITextField!{
    didSet {
      searchTextField.setRounded(radius: nil)
    }
  }
  @IBOutlet weak var backButton: UIButton! {
    didSet {
      backButton.tintColor = .gray01
    }
  }
  
  @IBOutlet weak var categoryTabbarView: CategoryTabbar! {
    didSet {
      categoryTabbarView.delegate = self
    }
  }
  
  
  private lazy var searchManager = SearchManager.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    searchTextField.returnKeyType = .search
    searchTextField.delegate = self
  }
}
extension SearchViewController: PagingTabbarDelegate {
  func scrollToIndex(to index: Int) {
    pageCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centerHorizontally, animated: true)
  }
}


//MARK: - Actions
extension SearchViewController {
  @IBAction private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}


//MARK: - delegate
extension SearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard searchTextField.text != "" else {return true}
    searchManager.saveSearchHistory(with: searchTextField.text)
    textField.resignFirstResponder()
    let searchResultStoryboard = UIStoryboard(name: "SearchResult", bundle: nil)
    guard let resultVC = searchResultStoryboard
            .instantiateViewController(identifier: "SearchResultViewController")
            as? SearchResultViewController else {
      return true
    }
    
    self.navigationController?.pushViewController(resultVC, animated: true)
    self.hidesBottomBarWhenPushed = true
    return true
  }
}
