//
//  MessageCell.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/26.
//

import UIKit

public class MessageCell: UICollectionViewCell {

  static let height: CGFloat = 64

  let profilePictureView = UIImageView()
  let nameLabel = UILabel()
  let recentChatLabel = UILabel()
  let recentChatTimeLabel = UILabel()

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
      nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12),
    ])

    addSubview(recentChatLabel)

    recentChatLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      recentChatLabel.leadingAnchor.constraint(equalTo: profilePictureView.trailingAnchor, constant: 12),
      recentChatLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 12),
      recentChatLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -64)
    ])
    recentChatLabel.font = UIFont.systemFont(ofSize: 14)
    recentChatLabel.adjustsFontSizeToFitWidth = false
    recentChatLabel.numberOfLines = 1
    recentChatLabel.lineBreakMode = .byTruncatingTail

    recentChatLabel.sizeToFit()
    recentChatLabel.textColor = .systemGray

    addSubview(recentChatTimeLabel)

    recentChatTimeLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      recentChatTimeLabel.leadingAnchor.constraint(equalTo: recentChatLabel.trailingAnchor),
      recentChatTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 12),
    ])
    recentChatTimeLabel.font = UIFont.systemFont(ofSize: 14)
    recentChatTimeLabel.adjustsFontSizeToFitWidth = false
    recentChatTimeLabel.numberOfLines = 1
    recentChatTimeLabel.sizeToFit()
    recentChatTimeLabel.textColor = .systemGray
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    profilePictureView.layer.cornerRadius = profilePictureView.bounds.width * 0.5
  }
}
