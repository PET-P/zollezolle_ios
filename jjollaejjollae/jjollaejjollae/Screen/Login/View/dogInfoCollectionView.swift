//
//  dogInfoCollectionView.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/14.
//

import UIKit

class dogInfoCollectionView: UICollectionView {
  // reloadData 이후에 일어날 일
  private var reloadDataCompletionBlock: (() -> Void)?
  
  private var findCenterBlock: (()->Void)?
  
  func reloadDataWithCompletion(_ complete: @escaping () -> Void) {
    reloadDataCompletionBlock = complete
    super.reloadData()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if let block = reloadDataCompletionBlock {
      block()
    }
  }
}

