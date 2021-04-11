//
//  ProfileEditViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/03.
//

import UIKit

public class ProfileEditViewController: UIViewController,
                                        ProfileEditViewDelegate,
                                        UITextFieldDelegate {

  var dismissTextEditingTapRecognizer: UIGestureRecognizer?

  public override func loadView() {
    let profileEditView = ProfileEditView()
    profileEditView.delegate = self
    profileEditView.textFieldDelegate = self
    view = profileEditView
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

    navigationItem.title = "Edit Profile"
  }

  // MARK: - Target Actions

  @objc func navigationBarCancelDidTap(_ sender: Any?) {
    let alert = UIAlertController(
      title: nil,
      message: "Are you sure you want to discard this profile changes?",
      preferredStyle: .actionSheet
    )

    alert.addAction(
      UIAlertAction(title: "Discard Changes", style: .destructive, handler: { (action) in
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
      message: "Do you want to save this profile changes?",
      preferredStyle: .alert
    )

    let profileEditView = view as! ProfileEditView

    alert.addAction(
      UIAlertAction(title: "Save Changes", style: .default, handler: { (action) in
        profileEditView.loadingIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          profileEditView.loadingIndicatorView.stopAnimating()
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

  // MARK: - ProfileEditViewDelegate

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
