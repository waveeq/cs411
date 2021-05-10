//
//  ShareSelectFriendCell.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/05/03.
//

import UIKit

public class ShareSelectFriendCell: UICollectionViewCell {

  static let height: CGFloat = 64

  let profilePictureView = UIImageView()
  let nameLabel = UILabel()

  var recentChatDate: Date?

  required init?(coder: NSCoder) {
    fatalError("nope!")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    profilePictureView.image = UIImage(named: "avatar_placeholder")
    profilePictureView.clipsToBounds = true
    addSubview(profilePictureView)

    profilePictureView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      profilePictureView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      profilePictureView.centerYAnchor.constraint(equalTo: centerYAnchor),
      profilePictureView.heightAnchor.constraint(equalTo: heightAnchor, constant: -24),
      profilePictureView.widthAnchor.constraint(equalTo: profilePictureView.heightAnchor),
    ])

    addSubview(nameLabel)
    nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    nameLabel.adjustsFontSizeToFitWidth = false
    nameLabel.numberOfLines = 1
    nameLabel.sizeToFit()

    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: profilePictureView.trailingAnchor, constant: 12),
      nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    profilePictureView.layer.cornerRadius = profilePictureView.bounds.width * 0.5
  }

  public func configure(with model: FriendModel) {
    nameLabel.text = model.name
  }

}
