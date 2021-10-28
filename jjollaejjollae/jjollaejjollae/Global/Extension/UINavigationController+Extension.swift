//
//  UINavigationController+Extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/20.
//

import UIKit

extension UINavigationController {
  func pushViewController(_ viewController :UIViewController, animated: Bool, completion: (() -> Void)?) {
    CATransaction.begin()
    CATransaction.setAnimationDuration(1)
    CATransaction.setCompletionBlock(completion)
    pushViewController(viewController, animated: true)
    CATransaction.commit()
  }
}

