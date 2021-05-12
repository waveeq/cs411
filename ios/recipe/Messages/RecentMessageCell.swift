//
//  MessageCell.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/26.
//

import UIKit

public class RecentMessageCell: UICollectionViewCell {

  static let height: CGFloat = 64

  let profilePictureView = UIImageView()
  let nameLabel = UILabel()
  let recentTextLabel = UILabel()
  let recentTextTimeLabel = UILabel()

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
      nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12),
    ])

    addSubview(recentTextLabel)

    recentTextLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      recentTextLabel.leadingAnchor.constraint(equalTo: profilePictureView.trailingAnchor, constant: 12),
      recentTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 12),
      recentTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -64)
    ])
    recentTextLabel.font = UIFont.systemFont(ofSize: 14)
    recentTextLabel.adjustsFontSizeToFitWidth = false
    recentTextLabel.numberOfLines = 1
    recentTextLabel.lineBreakMode = .byTruncatingTail

    recentTextLabel.sizeToFit()
    recentTextLabel.textColor = .systemGray

    addSubview(recentTextTimeLabel)

    recentTextTimeLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      recentTextTimeLabel.leadingAnchor.constraint(equalTo: recentTextLabel.trailingAnchor),
      recentTextTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 12),
    ])
    recentTextTimeLabel.font = UIFont.systemFont(ofSize: 14)
    recentTextTimeLabel.adjustsFontSizeToFitWidth = false
    recentTextTimeLabel.numberOfLines = 1
    recentTextTimeLabel.sizeToFit()
    recentTextTimeLabel.textColor = .systemGray
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    profilePictureView.layer.cornerRadius = profilePictureView.bounds.width * 0.5
  }

  public func configure(with messageModel: MessageModel) {
    let friendID = messageModel.senderID == AccountManager.sharedInstance.currentUserID
      ? messageModel.friendID
      : messageModel.senderID

    UserServices.sharedInstance.getUserProfile(forUserID: friendID) { userModel in
      guard let userModel = userModel else { return }

      self.profilePictureView.image = UIImage(named: "avatar_placeholder")
      if let profileImage = userModel.profileImage {
        UserServices.sharedInstance.loadImage(
          forUserID: userModel.userID,
          url: profileImage
        ) { image in
          self.profilePictureView.image = image
        }
      }

      self.nameLabel.text =
        userModel.firstName + " " + userModel.lastName + " (" + userModel.username + ")"

      self.recentTextLabel.text = messageModel.text
      self.recentTextLabel.font = UIFont.systemFont(ofSize: 14)

      let deltaTime = -messageModel.date.timeIntervalSinceNow
      if deltaTime >= 86400 {
        let daysDiff = Int(floor(deltaTime / 86400))
        self.recentTextTimeLabel.text = "・\(daysDiff)d"
      } else if deltaTime >= 3600 {
        let hoursDiff = Int(floor(deltaTime / 3600))
        self.recentTextTimeLabel.text = "・\(hoursDiff)h"
      } else {
        let minutesDiff = Int(floor(deltaTime / 60))
        self.recentTextTimeLabel.text = "・\(minutesDiff)m"
      }
    }

//    nameLabel.text = model.friend.name
//
//    guard let message = model.message else {
//      recentTextLabel.text = "No history - start chatting now!"
//      recentTextLabel.font = UIFont.italicSystemFont(ofSize: 14)
//      return
//    }
//
//    if message.isText {
//      recentTextLabel.text = message.text
//      recentTextLabel.font = UIFont.systemFont(ofSize: 14)
//    } else {
//      recentTextLabel.text = "Shared a recipe"
//      recentTextLabel.font = UIFont.italicSystemFont(ofSize: 14)
//    }
//
//    let deltaTime = -message.date.timeIntervalSinceNow
//    if deltaTime >= 86400 {
//      let daysDiff = Int(floor(deltaTime / 86400))
//      recentTextTimeLabel.text = "・\(daysDiff)d"
//    } else if deltaTime >= 3600 {
//      let hoursDiff = Int(floor(deltaTime / 3600))
//      recentTextTimeLabel.text = "・\(hoursDiff)h"
//    } else {
//      let minutesDiff = Int(floor(deltaTime / 60))
//      recentTextTimeLabel.text = "・\(minutesDiff)m"
//    }
  }

  public func configure(with searchUsernameModel: SearchUsernameModel) {
    UserServices.sharedInstance.getUserProfile(forUserID: searchUsernameModel.userID) { userModel in
      guard let userModel = userModel else { return }

      self.profilePictureView.image = UIImage(named: "avatar_placeholder")
      if let profileImage = userModel.profileImage {
        UserServices.sharedInstance.loadImage(
          forUserID: userModel.userID,
          url: profileImage
        ) { image in
          self.profilePictureView.image = image
        }
      }

      self.nameLabel.text =
        userModel.firstName + " " + userModel.lastName + " (" + userModel.username + ")"

      self.recentTextLabel.text = ""
      self.recentTextLabel.font = UIFont.systemFont(ofSize: 14)

      self.recentTextTimeLabel.text = ""
    }
  }
}
