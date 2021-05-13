//
//  SignUpView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import UIKit

public protocol SignUpViewDelegate: UIPickerViewDataSource,
                                    UIPickerViewDelegate,
                                    UITextFieldDelegate {
  func profileImageChangeDidTap()
}

public class SignUpView: UIView {

  let scrollView = UIScrollView()
  let containerView = UIView()

  let profileImageView = UIImageView(image: UIImage(named: "avatar_placeholder"))
  let profileImageSubtitle = UIButton()

  let firstNameLabel = UILabel()
  let firstNameTextField = UITextField()
  let lastNameLabel = UILabel()
  let lastNameTextField = UITextField()
  let usernameLabel = UILabel()
  let usernameTextField = UITextField()
  let countryLabel = UILabel()
  let countryPicker = UIPickerView()
  let emailLabel = UILabel()
  let emailTextField = UITextField()
  let birthdateLabel = UILabel()
  let birthdateDatePicker = UIDatePicker()

  let passwordLabel = UILabel()
  let newPasswordLabel = UILabel()
  let newPasswordTextField = UITextField()
  let reenterNewPasswordLabel = UILabel()
  let reenterNewPasswordTextField = UITextField()

  public weak var delegate: SignUpViewDelegate? {
    didSet {
      firstNameTextField.delegate = delegate
      lastNameTextField.delegate = delegate
      usernameTextField.delegate = delegate
      emailTextField.delegate = delegate
      newPasswordTextField.delegate = delegate
      reenterNewPasswordTextField.delegate = delegate
      countryPicker.dataSource = delegate
      countryPicker.delegate = delegate
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white

    // Scroll view

    addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
    ])

    // Contanier view
    scrollView.addSubview(containerView)

    // Profile Image

    containerView.addSubview(profileImageView)
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
      profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      profileImageView.widthAnchor.constraint(equalToConstant: 128),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
    ])
    profileImageView.clipsToBounds = true
    profileImageView.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(profileImageChangeDidTap(_:)))
    )

    // Profile Image label

    profileImageSubtitle.isEnabled = false
    profileImageSubtitle.alpha = 0.2
    profileImageSubtitle.setTitle("Upload Profile Photo", for: .normal)
    profileImageSubtitle.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    profileImageSubtitle.setTitleColor(.systemBlue, for: .normal)
    profileImageSubtitle.backgroundColor = nil
    containerView.addSubview(profileImageSubtitle)
    profileImageSubtitle.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      profileImageSubtitle.topAnchor.constraint(
        equalTo: profileImageView.bottomAnchor,
        constant: 12
      ),
      profileImageSubtitle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
    ])
    profileImageSubtitle.addTarget(
      self,
      action: #selector(profileImageChangeDidTap(_:)),
      for: .touchUpInside
    )

    // Separator

    let profileSeparatorView = UIView()
    containerView.addSubview(profileSeparatorView)
    profileSeparatorView.backgroundColor = UIColor(white: 0.9, alpha: 1)
    profileSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      profileSeparatorView.topAnchor.constraint(
        equalTo: profileImageSubtitle.bottomAnchor,
        constant: 12
      ),
      profileSeparatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
      profileSeparatorView.heightAnchor.constraint(equalToConstant: 1),
    ])

    // Username

    usernameLabel.text = "Username"
    containerView.addSubview(usernameLabel)
    usernameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      usernameLabel.topAnchor.constraint(equalTo: profileSeparatorView.bottomAnchor, constant: 12),
      usernameLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 24
      ),
      usernameLabel.widthAnchor.constraint(equalToConstant: 80),
    ])

    usernameTextField.autocapitalizationType = .none
    usernameTextField.text = nil
    usernameTextField.placeholder = "Username"
    usernameTextField.textContentType = .username
    usernameTextField.delegate = delegate
    containerView.addSubview(usernameTextField)
    usernameTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      usernameTextField.topAnchor.constraint(equalTo: usernameLabel.topAnchor),
      usernameTextField.bottomAnchor.constraint(equalTo: usernameLabel.bottomAnchor),
      usernameTextField.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 24),
      usernameTextField.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -24
      ),
    ])
    addUnderlineForView(usernameTextField)

    // First name

    firstNameLabel.text = "First name"
    containerView.addSubview(firstNameLabel)
    firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      firstNameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 24),
      firstNameLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 24
      ),
      firstNameLabel.widthAnchor.constraint(equalToConstant: 80),
    ])

    firstNameTextField.autocapitalizationType = .sentences
    firstNameTextField.text = nil
    firstNameTextField.placeholder = "First name"
    firstNameTextField.textContentType = .name
    firstNameTextField.delegate = delegate
    containerView.addSubview(firstNameTextField)
    firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.topAnchor),
      firstNameTextField.bottomAnchor.constraint(equalTo: firstNameLabel.bottomAnchor),
      firstNameTextField.leadingAnchor.constraint(equalTo: firstNameLabel.trailingAnchor, constant: 24),
      firstNameTextField.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -24
      ),
    ])
    addUnderlineForView(firstNameTextField)

    // Last name

    lastNameLabel.text = "Last name"
    containerView.addSubview(lastNameLabel)
    lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 24),
      lastNameLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 24
      ),
      lastNameLabel.widthAnchor.constraint(equalToConstant: 80),
    ])

    lastNameTextField.autocapitalizationType = .sentences
    lastNameTextField.text = nil
    lastNameTextField.placeholder = "Last name"
    lastNameTextField.textContentType = .name
    lastNameTextField.delegate = delegate
    containerView.addSubview(lastNameTextField)
    lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.topAnchor),
      lastNameTextField.bottomAnchor.constraint(equalTo: lastNameLabel.bottomAnchor),
      lastNameTextField.leadingAnchor.constraint(equalTo: lastNameLabel.trailingAnchor, constant: 24),
      lastNameTextField.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -24
      ),
    ])
    addUnderlineForView(lastNameTextField)

    // Email

    emailLabel.text = "Email"
    containerView.addSubview(emailLabel)
    emailLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emailLabel.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 24),
      emailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
      emailLabel.widthAnchor.constraint(equalToConstant: 80),
    ])

    emailTextField.autocapitalizationType = .none
    emailTextField.text = nil
    emailTextField.placeholder = "Email"
    emailTextField.textContentType = .emailAddress
    emailTextField.delegate = delegate
    containerView.addSubview(emailTextField)
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emailTextField.topAnchor.constraint(equalTo: emailLabel.topAnchor),
      emailTextField.bottomAnchor.constraint(equalTo: emailLabel.bottomAnchor),
      emailTextField.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 24),
      emailTextField.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -24
      ),
    ])
    addUnderlineForView(emailTextField)

    // Country

    countryLabel.text = "Country"
    containerView.addSubview(countryLabel)
    countryLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      countryLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 24),
      countryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
      countryLabel.widthAnchor.constraint(equalToConstant: 80),
      countryLabel.heightAnchor.constraint(equalToConstant: 80),
    ])

    countryPicker.dataSource = delegate
    countryPicker.delegate = delegate
    containerView.addSubview(countryPicker)
    countryPicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      countryPicker.topAnchor.constraint(equalTo: countryLabel.topAnchor),
      countryPicker.bottomAnchor.constraint(equalTo: countryLabel.bottomAnchor),
      countryPicker.leadingAnchor.constraint(equalTo: countryLabel.trailingAnchor, constant: 24),
      countryPicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
    ])
    addUnderlineForView(countryPicker)

    // Birthdate

    birthdateDatePicker.maximumDate = Date()
    birthdateLabel.text = "Birthday"
    containerView.addSubview(birthdateLabel)
    birthdateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      birthdateLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 24),
      birthdateLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 24
      ),
      birthdateLabel.widthAnchor.constraint(equalToConstant: 80),
    ])

    birthdateDatePicker.setDate(Date(timeIntervalSinceNow: 0), animated: false)
    birthdateDatePicker.datePickerMode = .date
    containerView.addSubview(birthdateDatePicker)
    birthdateDatePicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      birthdateDatePicker.topAnchor.constraint(equalTo: birthdateLabel.topAnchor),
      birthdateDatePicker.bottomAnchor.constraint(equalTo: birthdateLabel.bottomAnchor),
      birthdateDatePicker.leadingAnchor.constraint(equalTo: birthdateLabel.trailingAnchor, constant: 24),
      birthdateDatePicker.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -24
      ),
    ])

    // Separator

    let detailsSeparatorView = UIView()
    containerView.addSubview(detailsSeparatorView)
    detailsSeparatorView.backgroundColor = UIColor(white: 0.9, alpha: 1)
    detailsSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      detailsSeparatorView.topAnchor.constraint(
        equalTo: birthdateLabel.bottomAnchor,
        constant: 24
      ),
      detailsSeparatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
      detailsSeparatorView.heightAnchor.constraint(equalToConstant: 1),
    ])

    // Change password

    passwordLabel.text = "Password"
    passwordLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    containerView.addSubview(passwordLabel)
    passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      passwordLabel.topAnchor.constraint(equalTo: detailsSeparatorView.bottomAnchor, constant: 24),
      passwordLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 24
      ),
    ])

    // New password

    newPasswordLabel.text = "New"
    containerView.addSubview(newPasswordLabel)
    newPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      newPasswordLabel.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 12),
      newPasswordLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 24
      ),
      newPasswordLabel.widthAnchor.constraint(equalToConstant: 80),
    ])

    newPasswordTextField.autocapitalizationType = .none
    newPasswordTextField.text = nil
    newPasswordTextField.placeholder = "New Password"
    newPasswordTextField.isSecureTextEntry = true
    newPasswordTextField.textContentType = .newPassword
    newPasswordTextField.delegate = delegate
    containerView.addSubview(newPasswordTextField)
    newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      newPasswordTextField.topAnchor.constraint(equalTo: newPasswordLabel.topAnchor),
      newPasswordTextField.bottomAnchor.constraint(equalTo: newPasswordLabel.bottomAnchor),
      newPasswordTextField.leadingAnchor.constraint(equalTo: newPasswordLabel.trailingAnchor, constant: 24),
      newPasswordTextField.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -24
      ),
    ])
    addUnderlineForView(newPasswordTextField)

    // Re-enter password

    reenterNewPasswordLabel.text = "Re-enter"
    containerView.addSubview(reenterNewPasswordLabel)
    reenterNewPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      reenterNewPasswordLabel.topAnchor.constraint(equalTo: newPasswordLabel.bottomAnchor, constant: 24),
      reenterNewPasswordLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 24
      ),
      reenterNewPasswordLabel.widthAnchor.constraint(equalToConstant: 80),
    ])

    reenterNewPasswordTextField.autocapitalizationType = .none
    reenterNewPasswordTextField.text = nil
    reenterNewPasswordTextField.placeholder = "Re-enter New Password"
    reenterNewPasswordTextField.isSecureTextEntry = true
    reenterNewPasswordTextField.textContentType = .newPassword
    reenterNewPasswordTextField.delegate = delegate
    containerView.addSubview(reenterNewPasswordTextField)
    reenterNewPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      reenterNewPasswordTextField.topAnchor.constraint(equalTo: reenterNewPasswordLabel.topAnchor),
      reenterNewPasswordTextField.bottomAnchor.constraint(equalTo: reenterNewPasswordLabel.bottomAnchor),
      reenterNewPasswordTextField.leadingAnchor.constraint(equalTo: reenterNewPasswordLabel.trailingAnchor, constant: 24),
      reenterNewPasswordTextField.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -24
      ),
    ])
    addUnderlineForView(reenterNewPasswordTextField)

    // Register KVO

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(notification:)),
      name:UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(notification:)),
      name:UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    profileImageView.layer.cornerRadius = profileImageView.bounds.width * 0.5
    containerView.frame = CGRect(
      x: 0,
      y: 0,
      width: scrollView.safeAreaLayoutGuide.layoutFrame.width,
      height: reenterNewPasswordTextField.frame.maxY + 24
    )
    scrollView.contentSize = containerView.frame.size
  }

  // MARK: - Target Actions

  @objc public func profileImageChangeDidTap(_ sender: Any?) {
    delegate?.profileImageChangeDidTap()
  }

  // MARK: - KVO

  @objc func keyboardWillShow(notification:NSNotification){
    let userInfo = notification.userInfo!
    let keyboardFrame = convert(
      (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue,
      from: nil
    )

    var contentInset = scrollView.contentInset
    contentInset.bottom = keyboardFrame.height
    scrollView.contentInset = contentInset

    let contentOffset = CGPoint(
      x: 0,
      y: max(0, scrollView.contentSize.height - scrollView.bounds.height + keyboardFrame.height)
    )
    scrollView.setContentOffset(contentOffset, animated: true)
  }

  @objc func keyboardWillHide(notification:NSNotification){
    var contentInset = scrollView.contentInset
    contentInset.bottom = 0
    scrollView.contentInset = contentInset

    let contentOffset = CGPoint(
      x: 0,
      y: max(0, scrollView.contentSize.height - scrollView.bounds.height)
    )
    scrollView.setContentOffset(contentOffset, animated: true)
  }

  // MARK: - Helper

  func addUnderlineForView(_ targetView: UIView) {
    let underlineView = UIView()
    underlineView.backgroundColor = UIColor(white: 0.9, alpha: 1)
    containerView.addSubview(underlineView)
    underlineView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      underlineView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 8),
      underlineView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor),
      underlineView.widthAnchor.constraint(equalTo: targetView.widthAnchor),
      underlineView.heightAnchor.constraint(equalToConstant: 1),
    ])
  }
}
