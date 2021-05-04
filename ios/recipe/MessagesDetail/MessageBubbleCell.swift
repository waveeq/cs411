//
//  MessageBubbleCell.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/05/02.
//

import UIKit

public protocol MessageBubbleCellDelegate: class {
  func openSharedRecipePage(forRecipeID recipeID: Int)
}

public class MessageBubbleCell: UICollectionViewCell {

  weak var delegate: MessageBubbleCellDelegate?
  var model: MessageBubbleModel?

  let bubble = UIButton()
  let timestamp = UILabel()

  let label = UILabel()
  var textBaseConstraints: [NSLayoutConstraint]!

  let recipeImageView = UIImageView()
  let subtitle = UILabel()
  var shareRecipeBaseConstraints: [NSLayoutConstraint]!

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
    bubble.addTarget(self, action: #selector(openSharedRecipePage(_:)), for: .touchUpInside)

    // Label

    contentView.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false

    // Subtitle

    contentView.addSubview(subtitle)
    subtitle.text = "Tap to view recipe"
    subtitle.font = UIFont.italicSystemFont(ofSize: 10)
    subtitle.adjustsFontSizeToFitWidth = false
    subtitle.numberOfLines = 1
    subtitle.alpha = 0.5
    subtitle.translatesAutoresizingMaskIntoConstraints = false
    subtitle.sizeToFit()

    // Recipe Image

    contentView.addSubview(recipeImageView)
    recipeImageView.translatesAutoresizingMaskIntoConstraints = false

    // Timestamp

    contentView.addSubview(timestamp)
    timestamp.translatesAutoresizingMaskIntoConstraints = false
    timestamp.font = UIFont.systemFont(ofSize: 10)
    timestamp.adjustsFontSizeToFitWidth = false
    timestamp.numberOfLines = 1
    timestamp.alpha = 0.5

    // Constraints for text messages

    textBaseConstraints = [
      label.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8),
      timestamp.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -8),
      timestamp.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8),
      bubble.centerYAnchor.constraint(equalTo: centerYAnchor),
      bubble.widthAnchor.constraint(equalTo: label.widthAnchor, constant: 16),
      bubble.widthAnchor.constraint(greaterThanOrEqualTo: timestamp.widthAnchor, constant: 16),
      bubble.heightAnchor.constraint(equalTo: label.heightAnchor, constant: 16 + 20),
      label.centerXAnchor.constraint(equalTo: bubble.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: bubble.centerYAnchor, constant: -12),
    ]

    alignLeftConstraints = [
      bubble.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
    ]

    alignRightConstraints = [
      bubble.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
    ]

    // Constraints for share recipe messages

    shareRecipeBaseConstraints = [
      recipeImageView.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 12),
      recipeImageView.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -12),
      recipeImageView.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12),
      recipeImageView.widthAnchor.constraint(equalTo: recipeImageView.heightAnchor),
      label.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 8),
      label.centerYAnchor.constraint(equalTo: recipeImageView.centerYAnchor, constant: -4),
      label.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8),
      subtitle.leadingAnchor.constraint(equalTo: label.leadingAnchor),
      subtitle.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
      timestamp.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -8),
      timestamp.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8),
      bubble.centerYAnchor.constraint(equalTo: centerYAnchor),
      bubble.widthAnchor.constraint(equalTo: label.widthAnchor, constant: 12 + 80 + 8 + 12),
      bubble.widthAnchor.constraint(
        greaterThanOrEqualTo: subtitle.widthAnchor,
        constant: 12 + 80 + 8 + 12
      ),
      bubble.widthAnchor.constraint(greaterThanOrEqualTo: timestamp.widthAnchor, constant: 16),
      bubble.heightAnchor.constraint(equalToConstant: 80),
    ]
  }

  public override var intrinsicContentSize: CGSize {
    return bubble.frame.size
  }

//  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//    return bubble.hitTest(self.convert(point, to: bubble), with: event)
//  }

  public func configure(with model: MessageBubbleModel) {
    // Deactivate all
    NSLayoutConstraint.deactivate(textBaseConstraints)
    NSLayoutConstraint.deactivate(shareRecipeBaseConstraints)
    NSLayoutConstraint.deactivate(alignLeftConstraints)
    NSLayoutConstraint.deactivate(alignRightConstraints)

    let fromSelf = model.sender == AccountManager.sharedInstance.currentUserID
    bubble.backgroundColor = UIColor(white: fromSelf ? 0.8 : 0.9, alpha: 1)

    NSLayoutConstraint.activate(fromSelf ? alignRightConstraints : alignLeftConstraints)
    if model.isText {
      NSLayoutConstraint.activate(textBaseConstraints)
      label.text = model.text
      label.font = UIFont.systemFont(ofSize: 16)
      label.adjustsFontSizeToFitWidth = false
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping
      label.sizeToFit()

      bubble.isEnabled = false
      subtitle.isHidden = true
      recipeImageView.isHidden = true
    } else {

      print("===== model = \(model)")
      NSLayoutConstraint.activate(shareRecipeBaseConstraints)
      label.text = model.recipeName
      label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
      label.adjustsFontSizeToFitWidth = true
      label.numberOfLines = 1
      label.lineBreakMode = .byTruncatingTail
      label.sizeToFit()

      bubble.isEnabled = true
      subtitle.isHidden = false

      recipeImageView.backgroundColor = .systemGray
      recipeImageView.isHidden = false
      if let recipeID = model.recipeID, let imageURL = model.recipeImageURL {
        RecipeServices.sharedInstance.loadImageData(
          forRecipeID: recipeID,
          url: URL(string: imageURL)!
        ) { image in
          self.recipeImageView.image = image
        }
      }
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YY/MM/dd, HH:mm"
    timestamp.text = dateFormatter.string(from: model.date)
    timestamp.sizeToFit()

    self.model = model
  }

  // MARK: Target Action

  @objc func openSharedRecipePage(_ sender: Any?) {
    guard let recipeID = model?.recipeID else { return }

    delegate?.openSharedRecipePage(forRecipeID: recipeID)
  }

  // MARK: - Class methods

  public static func preferredSize(
    forModel model: MessageBubbleModel,
    parentView: UIView
  ) -> CGSize {
    if model.isText {
      let tempLabel = UILabel()

      tempLabel.font = UIFont.systemFont(ofSize: 16)
      tempLabel.adjustsFontSizeToFitWidth = false
      tempLabel.numberOfLines = 0
      tempLabel.lineBreakMode = .byWordWrapping
      tempLabel.text = model.text

      let estimatedHeight = tempLabel.sizeThatFits(
        CGSize(width: parentView.frame.width * 0.8, height: .greatestFiniteMagnitude)
      ).height

      return CGSize(width: parentView.frame.width, height: estimatedHeight + 36)
    } else {
      return CGSize(width: parentView.frame.width, height: 96)
    }
  }
}

