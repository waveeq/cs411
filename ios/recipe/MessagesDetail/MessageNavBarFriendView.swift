//
//  MessageNavBarFriendView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/26.
//

import UIKit

public class MessageNavBarFriendView: UIView {

  var friendImageView: UIImageView!
  var friendNameLabel: UILabel!

  required init(friend: UserModel) {
    super.init(frame: .zero)

    friendImageView = UIImageView(image: UIImage(named: "avatar_placeholder")!)
    friendImageView.clipsToBounds = true
    addSubview(friendImageView)

    if let profileImage = friend.profileImage {
      UserServices.sharedInstance.loadImage(
        forUserID: friend.userID,
        url: profileImage) { image in
        self.friendImageView.image = image
      }
    }

    friendNameLabel = UILabel()
    friendNameLabel.text = friend.fullName
    friendNameLabel.adjustsFontSizeToFitWidth = false
    friendNameLabel.numberOfLines = 1
    friendNameLabel.sizeToFit()
    addSubview(friendNameLabel)

    friendImageView.translatesAutoresizingMaskIntoConstraints = false
    friendNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      friendImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      friendImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      friendImageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -8),
      friendImageView.widthAnchor.constraint(equalTo: friendImageView.heightAnchor),
      friendNameLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 8),
      friendNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    friendImageView.layer.cornerRadius = friendImageView.bounds.width * 0.5
  }
}
