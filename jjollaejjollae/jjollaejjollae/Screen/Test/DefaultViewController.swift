//
//  DefaultViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/24.
//

import UIKit

class DefaultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      let infoView = DetailPlaceMainInfoView.instantiateFromNib()
      view.addSubview(infoView)
      
      infoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
