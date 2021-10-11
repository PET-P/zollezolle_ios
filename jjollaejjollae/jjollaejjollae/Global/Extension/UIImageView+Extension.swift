//
//  UIImageView+Extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/11.
//

import UIKit
import Kingfisher
import FirebaseStorage

extension UIImageView {
  func setImage(with UrlString: String) {
    let cache = ImageCache.default
    guard let newUrlString = UrlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {return}
    let imageUrl  = "\(StorageService.shared.imageBaseUrl)\(newUrlString)"
    cache.retrieveImage(forKey: newUrlString) { (result) in
      switch result {
      case .success(let value):
        if let image = value.image {
          self.image = image
        } else {
          let storage = Storage.storage()
          storage.reference(forURL: imageUrl).downloadURL { (url, error) in
            if let error = error {
              print("ERROR \(error.localizedDescription)")
              return
            }
            guard let url = url else {
              return
            }
            print("url???", url)
            self.kf.setImage(with: url)
          }
        }
      case .failure(let error):
        print("error \(error.localizedDescription)")
      }
    }
  }
}
