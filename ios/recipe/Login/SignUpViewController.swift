//
//  SignUpViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import UIKit

public class SignUpViewController: UIViewController, SignUpViewDelegate, UITextFieldDelegate {

  var dismissTextEditingTapRecognizer: UIGestureRecognizer?
  var countriesList: [[String:String]]? {
    if let path = Bundle.main.path(forResource: "Countries", ofType: "plist") {
      return NSArray(contentsOfFile: path) as? [[String:String]]
    }
    return nil
  }

  public override func loadView() {
    let signUpView = SignUpView()
    signUpView.delegate = self
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
    guard let signUpView = view as? SignUpView else { return }

    let alert = UIAlertController(
      title: nil,
      message: "Are you done filling in your profile for sign up?",
      preferredStyle: .alert
    )

    alert.addAction(
      UIAlertAction(title: "Sign Up", style: .default, handler: { (action) in
        let username = signUpView.usernameTextField.text
        let firstName = signUpView.firstNameTextField.text
        let lastName = signUpView.lastNameTextField.text
        let email = signUpView.emailTextField.text
        let country = self.countriesList?[signUpView.countryPicker.selectedRow(inComponent: 0)]["name"]
        let birthdate = signUpView.birthdateDatePicker.date

        signUpView.newPasswordTextField.isSecureTextEntry = false
        signUpView.reenterNewPasswordTextField.isSecureTextEntry = false
        let password = signUpView.newPasswordTextField.text
        let reenterPassword = signUpView.reenterNewPasswordTextField.text
        signUpView.newPasswordTextField.isSecureTextEntry = true
        signUpView.reenterNewPasswordTextField.isSecureTextEntry = true

        if let errorMessage = self.errorMessageIfApplicable(
            forUsername: username,
            firstName: firstName,
            lastName: lastName,
            email: email,
            country: country,
            birthdate: birthdate,
            password: password,
            reenterPassword: reenterPassword
        ) {
          let errorAlert = UIAlertController(
            title: "Sign Up Error",
            message: errorMessage,
            preferredStyle: .alert
          )
          errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
          self.present(errorAlert, animated: true)
          return;
        }

        LoadingOverlayView.startOverlay()
        UserServices.sharedInstance.registerNewUser(
          withUsername: username!,
          firstName: firstName!,
          lastName: lastName!,
          email: email!,
          country: country!,
          birthdate: birthdate,
          password: password!)
        { errorMessage in
          LoadingOverlayView.stopOverlay()

          if let errorMessage = errorMessage {
            let errorAlert = UIAlertController(
              title: "Sign Up Error",
              message: errorMessage,
              preferredStyle: .alert
            )
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(errorAlert, animated: true)
          } else {
            let successAlert = UIAlertController(
              title: "Sign Up Success",
              message: "A user with username \"\(username!)\" is successfully registered.",
              preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
              self.dismiss(animated: true, completion: nil)
            })
            self.present(successAlert, animated: true)
          }
        }
      })
    )
    alert.addAction(
      UIAlertAction(title: "Keep Editing", style: .cancel)
    )

    dismissTextEditing(nil)
    present(alert, animated: true)
  }

  func errorMessageIfApplicable(
    forUsername username: String?,
    firstName: String?,
    lastName: String?,
    email: String?,
    country: String?,
    birthdate: Date?,
    password: String?,
    reenterPassword: String?
  ) -> String? {
    if username?.count == 0 {
      return "Username can't be empty."
    }
    if firstName?.count == 0  {
      return "First name can't be empty"
    }
    if lastName?.count == 0  {
      return "Last name can't be empty"
    }
    if let email = email, email.count > 0 {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      if !emailPred.evaluate(with: email) {
        return "Email must be a valid email address."
      }
    } else {
      return "Email can't be empty"
    }
    if country?.count == 0 {
      return "Country can't be empty"
    }
    if let birthdate = birthdate {
      if birthdate.compare(Date()) == .orderedDescending {
        return "Birthdate must be in the past."
      }
    } else {
      return "Birthdate can't be empty."
    }
    if password?.count == 0 {
      return "Password can't be empty."
    }
    if password != reenterPassword {
      return "Re-entered password doesn't match the password."
    }
    return nil
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

  // MARK: - UIPickerViewDataSource
  
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return countriesList?.count ?? 0
  }

  // MARK: - UIPickerViewDelegate

  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return countriesList?[row]["name"]
  }
}

