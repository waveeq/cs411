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

public class TabViewController: UINavigationController, UINavigationControllerDelegate {

  var profileDiscView: ProfileDiscView!
  var bottomConstraint: NSLayoutConstraint!
  var topConstraint: NSLayoutConstraint!

  public var displayProfileDiscAtBottomRight: Bool = true {
    didSet {
      guard oldValue != displayProfileDiscAtBottomRight else { return }
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

    delegate = self
    navigationBar.prefersLargeTitles = true

    profileDiscView = ProfileDiscView()
    navigationBar.addSubview(profileDiscView)

    profileDiscView.translatesAutoresizingMaskIntoConstraints = false

    bottomConstraint = profileDiscView.bottomAnchor.constraint(
      equalTo: navigationBar.bottomAnchor,
      constant: -8
    )
    topConstraint = profileDiscView.topAnchor.constraint(
      equalTo: navigationBar.topAnchor,
      constant: 2
    )
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
      self.bottomConstraint.isActive = self.displayProfileDiscAtBottomRight
      self.topConstraint.isActive = !self.displayProfileDiscAtBottomRight
      self.navigationBar.setNeedsLayout()
      self.profileDiscView.setNeedsLayout()
      self.navigationBar.layoutIfNeeded()
      self.profileDiscView.layoutIfNeeded()
    }
  }

  // MARK: - UINavigationControllerDelegate

  public func navigationController(
    _ navigationController: UINavigationController,
    willShow viewController: UIViewController,
    animated: Bool
  ) {
    displayProfileDiscAtBottomRight = !viewController.isKind(of: MessageDetailViewController.self)
  }

}
