//
//  LoginView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import UIKit

public protocol LoginViewDelegate: UITextFieldDelegate {
  func login(withUsername username: String, password: String)
  func signUpButtonDidTap()
}

public class LoginView: UIView {

  public weak var delegate: LoginViewDelegate? {
    didSet {
      usernameTextField.delegate = delegate
      passwordTextField.delegate = delegate
    }
  }

  let titleLabel = UILabel()
  let usernameLabel = UILabel()
  let usernameTextField = InsettedTextField()
  let passwordLabel = UILabel()
  let passwordTextField = InsettedTextField()
  let loginButton = DarkButton()
  let signUpButton = DarkButton()

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

    usernameTextField.autocapitalizationType = .none
    usernameTextField.text = nil
    usernameTextField.placeholder = "Username"
    usernameTextField.textContentType = .name
    usernameTextField.delegate = delegate
    usernameTextField.layer.borderColor = UIColor.black.cgColor
    usernameTextField.layer.borderWidth = 2
    addSubview(usernameTextField)
    usernameTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
      usernameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
      usernameTextField.heightAnchor.constraint(equalToConstant: 44),
      usernameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
    ])

    usernameLabel.text = "Username"
    usernameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    addSubview(usernameLabel)
    usernameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      usernameLabel.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -8),
      usernameLabel.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
    ])

    // Password

    passwordLabel.text = "Password"
    passwordLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    addSubview(passwordLabel)
    passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 24),
      passwordLabel.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
    ])

    passwordTextField.autocapitalizationType = .none
    passwordTextField.text = nil
    passwordTextField.placeholder = "Password"
    passwordTextField.isSecureTextEntry = true
    passwordTextField.textContentType = .password
    passwordTextField.delegate = delegate
    passwordTextField.layer.borderColor = UIColor.black.cgColor
    passwordTextField.layer.borderWidth = 2
    addSubview(passwordTextField)
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
      passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
      passwordTextField.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor),
      passwordTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
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
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Target Actions

  @objc func loginButtonDidTap(_ sender: Any?) {
    guard let username = usernameTextField.text,
          let _ = passwordTextField.text
    else { return }

    passwordTextField.isSecureTextEntry = false
    let password = passwordTextField.text!
    passwordTextField.isSecureTextEntry = true
    delegate?.login(withUsername: username, password: password)
  }

  @objc func signUpButtonDidTap(_ sender: Any?) {
    delegate?.signUpButtonDidTap()
  }

}
