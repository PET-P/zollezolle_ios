//
//  DropDownDataSource.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/20.
//

import UIKit

class CellClass: UITableViewCell {
  
}

class DropDownDataSource: NSObject, UITableViewDataSource {
  var dataList = ["리뷰 많은순", "최근 등록순", "별점 높은순"]
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = dataList[indexPath.row]
    cell.textLabel?.font = .robotoMedium(size: 13)
    cell.textLabel?.textColor = .회
    cell.textLabel?.setContentHuggingPriority(.required, for: .horizontal)
    cell.textLabel?.textAlignment = .center
    cell.separatorInset = UIEdgeInsets.zero
    return cell
  }
}
