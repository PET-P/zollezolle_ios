//
//  FoldersData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import Foundation

struct FoldersData: Codable {
  let id: String
  let folder: [FolderData]
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case folder
  }
}
