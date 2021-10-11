//
//  StorageService.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/11.
//

import UIKit
import FirebaseStorage

class StorageService {
  
  static let shared = StorageService()
  private init() {}
  
  let storage = Storage.storage()
  let imageBaseUrl = "gs://zzollezzolle-b5298.appspot.com/images/"
  
  func uploadImage(img: UIImage, imageName: String) {
    var data = Data()
    data = img.jpegData(compressionQuality: 0.1)!
    guard let filePath = imageName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {return}
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg"
    storage.reference().child("images/\(filePath)").putData(data, metadata: metaData){
      (metaData, error) in
      if let error = error {
        print(error.localizedDescription)
      } else {
        print("성공")
      }
    }
  }
  
  func deleteImage(imageName: String){
    storage.reference().child("images").delete { (error) in
      if let error = error {
        print("지우는데 에러가 생겼다. \(error.localizedDescription)")
      } else {
        print("\(imageName)파일 지우는데 성공")
      }
    }
  }
}
