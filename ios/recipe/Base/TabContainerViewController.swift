//
//  TabContainerViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/20.
//

import UIKit

public class TabContainerViewController: UIViewController {

  let myRecipesTabViewController = TabViewController(tabType: .myRecipes)
  let exploreTabViewController = TabViewController(tabType: .explore)
  let messagesTabViewController = TabViewController(tabType: .messages)

  var activeTabViewController: TabViewController! {
    didSet {
      guard oldValue != activeTabViewController else { return }

      addChild(activeTabViewController)

      let tabView = activeTabViewController.view!
      view.addSubview(tabView)
      tabView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        tabView.topAnchor.constraint(equalTo: view.topAnchor),
        tabView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      ])

      activeTabViewController.didMove(toParent: self)

      if let oldValue = oldValue {
        UIView .transition(
          from: oldValue.view,
          to: tabView, duration: 0.2,
          options: .transitionCrossDissolve
        ) { (Bool) in
          oldValue.willMove(toParent: nil)
          oldValue.view.removeFromSuperview()
          oldValue.removeFromParent()
        }
      }
    }
  }

  public func showTab(_ tabType: TabType) {
    switch tabType {
    case .myRecipes:
      activeTabViewController = myRecipesTabViewController
    case .explore:
      activeTabViewController = exploreTabViewController
    case .messages:
      activeTabViewController = messagesTabViewController
    }
  }

  public func shareRecipe(
    _ recipeDetailModel: RecipeDetailModel,
    toFriend friend: OldFriendModel
  ) {
    popAllModalViewController(animated: true)
    messagesTabViewController.popToRootViewController(animated: false)
    messagesTabViewController.pushViewController(
      MessageDetailViewController(friend: friend, shareRecipe: recipeDetailModel),
      animated: false
    )
    activeTabViewController = messagesTabViewController
  }
}


extension UIViewController {

  func popAllModalViewController(animated: Bool) {
    guard let presentedViewController = self.presentedViewController else { return }

    presentedViewController.popAllModalViewController(animated: animated)
    presentedViewController.dismiss(animated: animated)
  }
}
