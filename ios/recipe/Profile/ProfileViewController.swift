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
    let profileEditNavigationController = UINavigationController(
      rootViewController: ProfileEditViewController()
    )
    profileEditNavigationController.modalTransitionStyle = .coverVertical
    profileEditNavigationController.modalPresentationStyle = .fullScreen
    present(profileEditNavigationController, animated: true, completion: nil)
  }

  public func logoutButtonDidTap() {
    let alert = UIAlertController(
      title: nil,
      message: "Are you sure you want to log out?",
      preferredStyle: .alert
    )

    alert.addAction(
      UIAlertAction(title: "Log out", style: .destructive, handler: { (action) in
        LoadingOverlayView.startOverlay()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          LoadingOverlayView.stopOverlay()
          self.navigationController?.popToRootViewController(animated: true)
        }
      })
    )
    alert.addAction(
      UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    )

    present(alert, animated: true, completion: nil)
  }

}
