//
//  LoginView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import UIKit

public protocol LoginViewDelegate: class {
  func loginButtonDidTap()
  func signUpButtonDidTap()
}

public class LoginView: UIView {

  public weak var delegate: LoginViewDelegate?
  public weak var textFieldDelegate: UITextFieldDelegate?

  let titleLabel = UILabel()
  let nameLabel = UILabel()
  let nameTextField = InsettedTextField()
  let passwordLabel = UILabel()
  let passwordTextField = InsettedTextField()
  let loginButton = DarkButton()
  let signUpButton = DarkButton()

  public let loadingIndicatorView = UIActivityIndicatorView()

  public override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white

    // Title

    titleLabel.text = "Recipe App"
    titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
    addSubview(titleLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: -220),
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])

    // Username

    nameTextField.text = nil
    nameTextField.placeholder = "Username"
    nameTextField.textContentType = .name
    nameTextField.delegate = textFieldDelegate
    nameTextField.layer.borderColor = UIColor.black.cgColor
    nameTextField.layer.borderWidth = 2
    addSubview(nameTextField)
    nameTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
      nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
      nameTextField.heightAnchor.constraint(equalToConstant: 44),
      nameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
    ])

    nameLabel.text = "Username"
    nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    addSubview(nameLabel)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -8),
      nameLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
    ])

    // Password

    passwordLabel.text = "Password"
    passwordLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    addSubview(passwordLabel)
    passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      passwordLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
      passwordLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
    ])

    passwordTextField.text = nil
    passwordTextField.placeholder = "Password"
    passwordTextField.isSecureTextEntry = true
    passwordTextField.textContentType = .password
    passwordTextField.delegate = textFieldDelegate
    passwordTextField.layer.borderColor = UIColor.black.cgColor
    passwordTextField.layer.borderWidth = 2
    addSubview(passwordTextField)
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
      passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
      passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
      passwordTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
    ])

    // Login button

    loginButton.setTitle("Login", for: .normal)
    addSubview(loginButton)
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
      loginButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
      loginButton.heightAnchor.constraint(equalToConstant: 44),
      loginButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
    ])
    loginButton.addTarget(self, action: #selector(loginButtonDidTap(_:)), for: .touchUpInside)

    // Sign up button

    signUpButton.setTitle("Sign Up", for: .normal)
    addSubview(signUpButton)
    signUpButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
      signUpButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
      signUpButton.heightAnchor.constraint(equalToConstant: 44),
      signUpButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
    ])
    signUpButton.addTarget(self, action: #selector(signUpButtonDidTap(_:)), for: .touchUpInside)

    // Loading indicator view

    addSubview(loadingIndicatorView)
    loadingIndicatorView.hidesWhenStopped = true
    loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
      loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
      loadingIndicatorView.heightAnchor.constraint(equalToConstant: 64),
      loadingIndicatorView.widthAnchor.constraint(equalTo: loadingIndicatorView.heightAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Target Actions

  @objc func loginButtonDidTap(_ sender: Any?) {
    delegate?.loginButtonDidTap()
  }

  @objc func signUpButtonDidTap(_ sender: Any?) {
    delegate?.signUpButtonDidTap()
  }

}
