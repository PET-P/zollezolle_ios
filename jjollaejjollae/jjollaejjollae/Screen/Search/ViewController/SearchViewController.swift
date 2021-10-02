//
//  SearchViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/14.
//

import UIKit

class SearchViewController: UIViewController, StoryboardInstantiable {
  
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
  
  @IBOutlet weak var categoryTabbarView: CategoryTabbar!
  {
    didSet {
      categoryTabbarView.delegate = self
    }
  }
  
  @IBOutlet weak var pageCollectionView: UICollectionView! {
    didSet {
      pageCollectionView.dataSource = self
      pageCollectionView.delegate = self
      pageCollectionView.showsHorizontalScrollIndicator = false
      pageCollectionView.isPagingEnabled = true
    }
  }
  
  private lazy var searchManager = SearchManager.shared
  let colorSet: [UIColor] = [.systemRed, .systemOrange]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    searchTextField.returnKeyType = .search
    searchTextField.delegate = self
    print("wholeview :", view.frame.width);
    print("category tabbarview", categoryTabbarView.indicatorView.frame.width);
  }
}
//MARK: - PagingCollectionView

extension SearchViewController: PagingTabbarDelegate, UICollectionViewDelegateFlowLayout {
  
  func scrollToIndex(to index: Int) {
    pageCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    categoryTabbarView.indicatorLeadingConstraint.constant = scrollView.contentOffset.x / 2 - 40 < 0 ? 0 : scrollView.contentOffset.x / 2 - 40
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let page = Int(targetContentOffset.pointee.x / pageCollectionView.frame.width)
    categoryTabbarView.scroll(to: page)
  }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colorSet.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath)
    if indexPath.row == 0 {
      display(contentController: StarsSearchViewController.loadFromStoryboard()
              as! StarsSearchViewController, on: cell.contentView)
    } else {
      display(contentController: RecentSearchViewController.loadFromStoryboard()
              as! RecentSearchViewController, on: cell.contentView)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    let height = collectionView.frame.height
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func display(contentController content: UIViewController, on view: UIView) {
    self.addChild(content)
    content.view.frame = view.bounds
    view.addSubview(content.view)
    content.didMove(toParent: self)
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
