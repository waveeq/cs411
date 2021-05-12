//
//  RootViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/17.
//

import UIKit

@objc public protocol RootResponderChainActions: AnyObject {
  func showProfileView(_ sender: Any?)
}

public class RootViewController: UIViewController,
                                 FooterDelegate,
                                 RootResponderChainActions,
                                 UINavigationControllerDelegate,
                                 UIPageViewControllerDataSource {

  let footerViewController = FooterViewController()
  lazy var footerHeightConstraint =
    footerViewController.view!.heightAnchor.constraint(equalToConstant: 0)

  let pageViewController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal,
    options: nil
  )
  let tabContainerViewController = TabContainerViewController()
  let profileViewController = ProfileViewController()

  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    // Set up pages

    tabContainerViewController.showTab(.myRecipes)

    pageViewController.dataSource = self
    pageViewController.setViewControllers(
      [tabContainerViewController],
      direction: .forward,
      animated: false,
      completion: nil
    )
    addChild(pageViewController)

    let pageView = pageViewController.view!
    view.addSubview(pageView)
    pageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      pageView.topAnchor.constraint(equalTo: view.topAnchor),
      pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    pageViewController.didMove(toParent: self)

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

    pageViewController.additionalSafeAreaInsets = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: footerHeight,
      right: 0
    )
  }

  public override func viewSafeAreaInsetsDidChange() {
    super.viewSafeAreaInsetsDidChange()

    let footerView = footerViewController.view!
    footerHeightConstraint.constant =
      footerView.intrinsicContentSize.height + view.safeAreaInsets.bottom
  }

  public func showTab(_ targetTabType: TabType) {
    if let _ = pageViewController.viewControllers?.first as? TabContainerViewController {
      tabContainerViewController.showTab(targetTabType)
    } else {

      UIView.performWithoutAnimation {
        self.tabContainerViewController.showTab(targetTabType)
      }

      pageViewController.setViewControllers(
        [tabContainerViewController],
        direction: .reverse,
        animated: true,
        completion: nil
      )
    }

    footerViewController.tabDidChange(to: targetTabType)
  }

  // MARK: - FooterDelegate

  public func footerButtonTapped(sender: Any?) {
    guard let footerButton = sender as? FooterButton else { return }

    showTab(footerButton.targetTabType)
  }

  // MARK: - UIPageViewControllerDataSource

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    return viewController.isKind(of: TabContainerViewController.self) ? profileViewController : nil
  }

  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    return viewController.isKind(of: ProfileViewController.self) ? tabContainerViewController : nil
  }

  // MARK: - Target Actions

  @objc public func showProfileView(_ sender: Any?) {
    pageViewController.setViewControllers(
      [profileViewController],
      direction: .forward,
      animated: true,
      completion: nil
    )
  }

  public func shareRecipe(
    _ recipeDetailModel: RecipeDetailModel,
    toFriend friend: OldFriendModel
  ) {
    tabContainerViewController.shareRecipe(recipeDetailModel, toFriend: friend)
    footerViewController.tabDidChange(to: .messages)
  }
}
