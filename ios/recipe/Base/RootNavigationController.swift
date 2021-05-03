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

  public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
}

public extension UIViewController {

  @objc var rootViewController: RootViewController? {
    if let self = self as? RootViewController {
      return self
    }

    if let presentingViewController = presentingViewController {
      return presentingViewController.rootViewController
    }

    return navigationController?.rootViewController
  }
}

public extension UINavigationController {

  @objc override var rootViewController: RootViewController? {
    if let rootViewController = viewControllers.first as? RootViewController {
      return rootViewController
    }

    if let rootViewController = topViewController as? RootViewController {
      return rootViewController
    }

    return parent?.rootViewController
  }
}
