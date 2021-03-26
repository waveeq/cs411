//
//  RootViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/17.
//

import UIKit

public class RootViewController: UIViewController, FooterDelegate {

  let footerViewController = FooterViewController()
  lazy var footerHeightConstraint = footerViewController.view!.heightAnchor.constraint(equalToConstant: 0)

  let tabContainerViewController = TabContainerViewController()

  public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    // Set up Content Navigation VC.

    addChild(tabContainerViewController)

    let tabContainerView = tabContainerViewController.view!
    view.addSubview(tabContainerView)
    tabContainerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tabContainerView.topAnchor.constraint(equalTo: view.topAnchor),
      tabContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tabContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tabContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    tabContainerViewController.showTab(.myRecipes)

    // Set up Footer VC.

    footerViewController.delegate = self
    addChild(footerViewController)

    let footerView = footerViewController.view!
    view.addSubview(footerView)

    let footerHeight = footerView.intrinsicContentSize.height
    footerHeightConstraint.constant = footerHeight + footerView.safeAreaInsets.bottom

    footerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      footerHeightConstraint,
      footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    footerViewController.didMove(toParent: self)

    tabContainerViewController.additionalSafeAreaInsets = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: footerHeight,
      right: 0
    )
  }


  public override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()

    let footerView = footerViewController.view!
    footerHeightConstraint.constant = footerView.intrinsicContentSize.height + view.safeAreaInsets.bottom
  }

  // MARK: - FooterDelegate

  public func footerButtonTapped(sender: Any?) {
    guard let footerButton = sender as? FooterButton else { return }

    tabContainerViewController.showTab(footerButton.targetTabType)
  }  
}

