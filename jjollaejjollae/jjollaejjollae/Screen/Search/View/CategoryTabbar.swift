//
//  CategoryTabbar.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/30.
//

import UIKit

protocol PagingTabbarDelegate: AnyObject {
  func scrollToIndex(to index: Int)
}

class CategoryTabbar: UIView {
  //nibName을 써주는 순간 load는 밖에서 진행하는 것으로 하자
  static let nibName = ""
  private var view: UIView!
  weak var delegate: PagingTabbarDelegate?
  var titleList = ["인기키워드", "최근 검색어"]
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  
  //페이지를 표시할 Tabbar
  @IBOutlet weak var categoryCollectionView: UICollectionView! {
    didSet {
      categoryCollectionView.dataSource = self
      categoryCollectionView.delegate = self
      categoryCollectionView.register(UINib(nibName: CategoryCell.nibName, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
      categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
    }
  }
  
  func scroll(to index: Int) {
    categoryCollectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: [])
  }
  // indicator로 현재 페이지를 표시
  var indicatorView: UIView = {
    let indicatorView = UIView()
    indicatorView.backgroundColor = .themePaleGreen
    indicatorView.translatesAutoresizingMaskIntoConstraints = false
    return indicatorView
  }()
  
  var indicatorLeadingConstraint: NSLayoutConstraint!
  
  private func setConstraint() {
    indicatorLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            NSLayoutConstraint.activate([
              indicatorView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor),
              indicatorView.widthAnchor.constraint(equalToConstant: categoryCollectionView.frame.width/2),
              indicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
              indicatorLeadingConstraint
            ])
  }
  
}

extension CategoryTabbar: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.titleList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
    cell.titleLabel.text = titleList[indexPath.row]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.scrollToIndex(to: indexPath.row)
  }
}
