//
//  PagingManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/14.
//

import UIKit

class PagingManager {
  static let shared = PagingManager()
  public init() {}
  var mainVC: UIViewController?
  var myInfoVC: UIViewController?
  private var Pets: [(pet: PetData, image: UIImage?)] = []
  
  private var dogTuples: [(pet: PetData, image: UIImage?)] = [] {
    didSet {
      print(dogTuples)
    }
  }
  
  private var dogRepresent: UIImage?
  
  func setDogRepresent(dogImage: UIImage) {
    self.dogRepresent = dogImage
  }
  
  func getDogRepresent() -> UIImage {
    return self.dogRepresent ?? UIImage(named: "default")!
  }
  
  func setDogTuples(dogTuples: [(pet: PetData, image: UIImage?)]) {
    self.dogTuples = dogTuples
  }
  
  func getDogTuples() -> [(pet: PetData, image: UIImage?)] {
    return dogTuples
  }
  
  
}
