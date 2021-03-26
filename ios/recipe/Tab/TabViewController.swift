//
//  TabViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/20.
//

import UIKit

public enum TabType {
  case myRecipes
  case explore
  case messages
}

public class TabViewController: UINavigationController {

  var profileDiscView: ProfileDiscView!
  var bottomConstraint: NSLayoutConstraint!
  var topConstraint: NSLayoutConstraint!

  public var displayAtBottomRight: Bool = true {
    didSet {
      guard oldValue != displayAtBottomRight else { return }
      updateProfileDiscPosition()
    }
  }

  required init(tabType: TabType) {
    var rootViewController: UIViewController

    switch tabType {
    case .myRecipes:
      rootViewController = MyRecipesViewController()
    case .explore:
      rootViewController = ExploreViewController()
    case .messages:
      rootViewController = MessagesViewController()
    }

    super.init(rootViewController: rootViewController)

    navigationBar.prefersLargeTitles = true

    profileDiscView = ProfileDiscView()
    navigationBar.addSubview(profileDiscView)

    profileDiscView.translatesAutoresizingMaskIntoConstraints = false

    bottomConstraint = profileDiscView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -8)
    topConstraint = profileDiscView.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 8)
    NSLayoutConstraint.activate([
      profileDiscView.heightAnchor.constraint(equalToConstant: profileDiscView.imageSize),
      profileDiscView.widthAnchor.constraint(equalTo: profileDiscView.heightAnchor),
      profileDiscView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -20),
      bottomConstraint
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateProfileDiscPosition() {

    // TODO(Dikra): Consider custom pane transition.
    UIView.animate(withDuration: 0.3) {
      self.bottomConstraint.isActive = self.displayAtBottomRight
      self.topConstraint.isActive = !self.displayAtBottomRight
      self.navigationBar.setNeedsLayout()
      self.profileDiscView.setNeedsLayout()
      self.navigationBar.layoutIfNeeded()
      self.profileDiscView.layoutIfNeeded()
    }
  }

}

public extension UIViewController {
  var hostTabViewController: TabViewController? {
    return self.navigationController as? TabViewController
  }
}
