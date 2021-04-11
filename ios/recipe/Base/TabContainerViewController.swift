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

  var activeTabViewController: UIViewController! {
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
}
