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
  var myPetInfoVC: UIViewController?
  
  private var dogTuples: [(petdata: PetData, image: UIImage?)] = []
  
  private var dogRepresent: UIImage?
  
  func setDogRepresent(dogImage: UIImage) {
    self.dogRepresent = dogImage
  }
  
  func getDogRepresent() -> UIImage {
    return self.dogRepresent ?? UIImage(named: "default")!
  }
  
  func setDogTuples(dogTuples: [(petdata: PetData, image: UIImage?)]) {
    self.dogTuples = dogTuples
  }
  
  func getDogTuples() -> [(petdata: PetData, image: UIImage?)] {
    return dogTuples
  }
}
