//
//  ProfileViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/03.
//

import UIKit

public class ProfileViewController: UIViewController, ProfileViewDelegate {

  public override func loadView() {
    let profileView = ProfileView()
    profileView.delegate = self
    view = profileView
  }

  // MARK: - ProfileViewDelegate

  public func editProfileButtonDidTap() {
    let editViewNavigationController = UINavigationController(rootViewController: ProfileEditViewController())
    editViewNavigationController.modalTransitionStyle = .coverVertical
    editViewNavigationController.modalPresentationStyle = .fullScreen
    present(editViewNavigationController, animated: true, completion: nil)
  }

  public func logoutButttonDidTap() {
    let alert = UIAlertController(
      title: nil,
      message: "Are you sure you want to log out?",
      preferredStyle: .alert
    )

    alert.addAction(
      UIAlertAction(title: "Log Out", style: .destructive, handler: { (action) in

      })
    )
    alert.addAction(
      UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    )

    present(alert, animated: true, completion: nil)
  }

}
