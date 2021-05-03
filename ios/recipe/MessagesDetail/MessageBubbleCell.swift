//
//  MessageBubbleCell.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/05/02.
//

import UIKit

public class MessageBubbleCell: UICollectionViewCell {

  let bubble = UIView()
  let label = UILabel()
  let timestamp = UILabel()

  var alignLeftConstraints: [NSLayoutConstraint]!
  var alignRightConstraints: [NSLayoutConstraint]!

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white

    // Bubble

    contentView.addSubview(bubble)
    bubble.translatesAutoresizingMaskIntoConstraints = false
    bubble.backgroundColor = UIColor(white: 0.9, alpha: 1)
    bubble.layer.cornerRadius = 8
    bubble.clipsToBounds = false

    // Label

    contentView.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16)
    label.adjustsFontSizeToFitWidth = false
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping

    // Timestamp

    contentView.addSubview(timestamp)
    timestamp.translatesAutoresizingMaskIntoConstraints = false
    timestamp.font = UIFont.systemFont(ofSize: 10)
    timestamp.adjustsFontSizeToFitWidth = false
    timestamp.numberOfLines = 1
    timestamp.alpha = 0.5

    NSLayoutConstraint.activate([
      label.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8),
      timestamp.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -8),
      timestamp.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8),
      bubble.centerYAnchor.constraint(equalTo: centerYAnchor),
      bubble.widthAnchor.constraint(equalTo: label.widthAnchor, constant: 16),
      bubble.widthAnchor.constraint(greaterThanOrEqualTo: timestamp.widthAnchor, constant: 16),
      bubble.heightAnchor.constraint(equalTo: label.heightAnchor, constant: 16 + 20),
      label.centerXAnchor.constraint(equalTo: bubble.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: bubble.centerYAnchor, constant: -12),
    ])

    alignLeftConstraints = [
      bubble.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
    ]

    alignRightConstraints = [
      bubble.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
    ]
  }

  public override var intrinsicContentSize: CGSize {
    return bubble.frame.size
  }

  public func configure(with model: MessageBubbleModel) {
    if model.sender == AccountManager.sharedInstance.currentUserID {
      bubble.backgroundColor = UIColor(white: 0.8, alpha: 1)
      NSLayoutConstraint.deactivate(alignLeftConstraints)
      NSLayoutConstraint.activate(alignRightConstraints)
    } else {
      bubble.backgroundColor = UIColor(white: 0.9, alpha: 1)
      NSLayoutConstraint.deactivate(alignRightConstraints)
      NSLayoutConstraint.activate(alignLeftConstraints)
    }

    label.text = model.text
    label.sizeToFit()

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY/MM/dd, HH:mm"
    timestamp.text = dateFormatter.string(from: model.date)
    timestamp.sizeToFit()
  }
}

