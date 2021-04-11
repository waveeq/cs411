//
//  SignUpViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import UIKit

import UIKit

public class SignUpViewController: UIViewController, SignUpViewDelegate, UITextFieldDelegate {

  var dismissTextEditingTapRecognizer: UIGestureRecognizer?

  public override func loadView() {
    let signUpView = SignUpView()
    signUpView.delegate = self
    signUpView.textFieldDelegate = self
    view = signUpView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(navigationBarCancelDidTap(_:))
    )

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(navigationBarDoneDidTap(_:))
    )

    navigationItem.title = "Sign Up"
  }

  // MARK: - Target Actions

  @objc func navigationBarCancelDidTap(_ sender: Any?) {
    let alert = UIAlertController(
      title: nil,
      message: "Are you sure you want to close without signing up?",
      preferredStyle: .actionSheet
    )

    alert.addAction(
      UIAlertAction(title: "Close Sign Up", style: .destructive, handler: { (action) in
        self.dismiss(animated: true, completion: nil)
      })
    )
    alert.addAction(
      UIAlertAction(title: "Keep Editing", style: .cancel, handler: nil)
    )

    dismissTextEditing(nil)
    present(alert, animated: true, completion: nil)
  }

  @objc func navigationBarDoneDidTap(_ sender: Any?) {
    let alert = UIAlertController(
      title: nil,
      message: "Are you done filling in your profile for sign up?",
      preferredStyle: .alert
    )

    let signUpView = view as! SignUpView

    alert.addAction(
      UIAlertAction(title: "Sign Up", style: .default, handler: { (action) in
        signUpView.loadingIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          signUpView.loadingIndicatorView.stopAnimating()
          self.dismiss(animated: true, completion: nil)
        }
      })
    )
    alert.addAction(
      UIAlertAction(title: "Keep Editing", style: .cancel, handler: nil)
    )

    dismissTextEditing(nil)
    present(alert, animated: true, completion: nil)
  }

  // MARK: - SignUpViewDelegate

  public func profileImageChangeDidTap() {

  }

  // MARK: - UITextFieldDelegate

  @objc func dismissTextEditing(_ sender: Any?) {
    view.endEditing(true)
  }

  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    dismissTextEditingTapRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissTextEditing(_:))
    )
    view.addGestureRecognizer(dismissTextEditingTapRecognizer!)
    return true
  }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    if let _ = dismissTextEditingTapRecognizer {
      view.removeGestureRecognizer(dismissTextEditingTapRecognizer!)
    }
    dismissTextEditingTapRecognizer = nil
  }

  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

