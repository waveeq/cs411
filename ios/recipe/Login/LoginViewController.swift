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

  public func loginButtonDidTap() {
    let loginView = view as! LoginView

    LoadingOverlayView.startOverlay()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.navigationController?.pushViewController(RootViewController(), animated: true)
      LoadingOverlayView.stopOverlay()
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
