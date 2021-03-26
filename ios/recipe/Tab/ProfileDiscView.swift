//
//  ProfileDiscView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/20.
//

import UIKit

public class ProfileDiscView: UIView {

  let placeholderAssetName = "avatar_placeholder"
  public let imageSize: CGFloat = 44

  var profileImageView: UIImageView!

  override required init(frame: CGRect) {
    super.init(frame: frame)

    let profileImage = UIImage(named: placeholderAssetName)
    profileImageView = UIImageView(image: profileImage)

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

}
