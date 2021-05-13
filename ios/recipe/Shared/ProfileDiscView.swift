//
//  ProfileDiscView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/20.
//

import UIKit

public class ProfileDiscView: UIView {

  public let imageSize: CGFloat = 44

  var profileImageView: UIImageView!

  override required init(frame: CGRect) {
    super.init(frame: frame)

    let userID = AccountManager.sharedInstance.currentUserID
    profileImageView = UIImageView(image: UIImage(named: "avatar_placeholder"))
    UserServices.sharedInstance.getUserProfile(forUserID: userID) { userModel in
      if let profileImage = userModel?.profileImage {
        UserServices.sharedInstance.loadImage(
          forUserID: userID, url: profileImage) { image in
          self.profileImageView.image = image
        }
      }
    }

    addSubview(profileImageView)
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: topAnchor),
      profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])

    profileImageView.layer.cornerRadius = imageSize * 0.5
    profileImageView.clipsToBounds = true

    // TODO(Dikra): Investigate why sending action to target nil does not work.
    addGestureRecognizer(
      UITapGestureRecognizer(
        target: self,
        action: #selector(profileDiscDidTap(_:))
      )
    )
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override var intrinsicContentSize: CGSize {
    return CGSize(width: imageSize, height: imageSize)
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    profileImageView.layer.cornerRadius = frame.height * 0.5
  }

  // MARK: - Target Actions

  @objc func profileDiscDidTap(_ sender: Any?) {
    UIApplication.shared.sendAction(
      #selector(RootResponderChainActions.showProfileView(_:)),
      to: nil,
      from: self,
      for: nil
    )
  }
}
