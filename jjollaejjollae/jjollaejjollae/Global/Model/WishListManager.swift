//
//  WishListManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/19.
//

import Foundation

class WishListManager {
  
  private var wishModel: Wish?
  
  func setWish(wish: Wish?) {
    wishModel = wish
  }
  
  func getWish() -> Wish? {
    return wishModel
  }
  
}
