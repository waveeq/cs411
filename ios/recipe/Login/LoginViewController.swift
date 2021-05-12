//
//  LoginViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import UIKit

public class LoginViewController: UIViewController, LoginViewDelegate {

  public override func loadView() {
    let loginView = LoginView()
    loginView.delegate = self
    view = loginView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.isNavigationBarHidden = true
  }

  // MARK: - LoginViewDelegate

  public func login(withUsername username: String, password: String) {
    LoadingOverlayView.startOverlay()

    AccountManager.sharedInstance.login(
      withUsername: username, password: password) { userModel in
      if let _ = userModel {
        self.navigationController?.pushViewController(RootViewController(), animated: true)
        LoadingOverlayView.stopOverlay()
      } else {
        let alert = UIAlertController(
          title: "Login Error",
          message: "Incorrect username or password.",
          preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))

        self.present(alert, animated: true, completion: nil)
      }
    }
  }

  public func signUpButtonDidTap() {
    let signUpNavigationController = UINavigationController(
      rootViewController: SignUpViewController()
    )
    signUpNavigationController.modalTransitionStyle = .coverVertical
    signUpNavigationController.modalPresentationStyle = .fullScreen
    present(signUpNavigationController, animated: true, completion: nil)
  }
}
