//
//  RootNavigationController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/20.
//

import UIKit

public class RootNavigationController: UINavigationController {

  required override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)

    isNavigationBarHidden = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
