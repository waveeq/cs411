//
//  RecipeDetailView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/26.
//

import UIKit

public protocol RecipeDetailViewDelegate: class, UITextViewDelegate {
  func favoriteButtonDidTap(_ favoriteButton: UIButton)
}

public class RecipeDetailView: UIScrollView {

  public weak var recipeDetailViewDelegate: RecipeDetailViewDelegate? {
    didSet {
      notesTextView.delegate = recipeDetailViewDelegate
    }
  }

  let containerView = UIView()
  var containerViewBottomConstraintWithNotes: NSLayoutConstraint!
  var containerViewBottomConstraintWithoutNotes: NSLayoutConstraint!

  let titleLabel = UILabel()
  let sourceLabel = UILabel()
  let imageView = UIImageView()
  let ratingStarsView = RatingStarsView()
  let ratingLabel = UILabel()
  let favoriteButton = UIButton()
  let chatButton = UIButton()

  let recipeDetailsTitleLabel = UILabel()
  let recipeDetailsContentLabel = UILabel()

  let notesLabel = UILabel()
  let notesTextView = UITextView()

  var initialNotesText: String? = nil

  public override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white
    contentInsetAdjustmentBehavior = .automatic

    // Container view

    containerView.isHidden = true
    addSubview(containerView)

    // Title

    titleLabel.text = "Delicious Food"
    titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.minimumScaleFactor = 0.1
    titleLabel.numberOfLines = 1
    containerView.addSubview(titleLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
    ])

    sourceLabel.text = "http://allrecipe.com/lorem/ipsum"
    sourceLabel.font = UIFont.systemFont(ofSize: 14)
    sourceLabel.textColor = .systemGray
    containerView.addSubview(sourceLabel)

    sourceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      sourceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      sourceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
    ])

    // Image view

    imageView.contentMode = .scaleAspectFill
    containerView.addSubview(imageView)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 8),
      imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
    ])

    // Ratings

    containerView.addSubview(ratingStarsView)

    ratingLabel.text = ratingToString(ratingAverage: 5, ratingCount: 1200)
    ratingLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    ratingLabel.adjustsFontSizeToFitWidth = false
    ratingLabel.numberOfLines = 1
    containerView.addSubview(ratingLabel)

    ratingLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingLabel.centerYAnchor.constraint(equalTo: ratingStarsView.centerYAnchor),
      ratingLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
    ])

    ratingStarsView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ratingStarsView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
      ratingStarsView.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -8),
      ratingStarsView.heightAnchor.constraint(equalToConstant: 18),
      ratingStarsView.widthAnchor.constraint(equalToConstant: 98)
    ])

    // Favorite & Chat Buttons

    favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
    favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    favoriteButton.imageView?.contentMode = .scaleAspectFit
    favoriteButton.contentVerticalAlignment = .fill
    favoriteButton.contentHorizontalAlignment = .fill
    favoriteButton.tintColor = .black
    favoriteButton.addTarget(self, action: #selector(favoriteButtonDidTap(_:)), for: .touchUpInside)
    containerView.addSubview(favoriteButton)

    favoriteButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      favoriteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
      favoriteButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
      favoriteButton.widthAnchor.constraint(equalToConstant: 32),
      favoriteButton.heightAnchor.constraint(equalToConstant: 32),
    ])

    chatButton.setImage(
      UIImage(systemName: "message")?.withHorizontallyFlippedOrientation(),
      for: .normal
    )

    chatButton.imageView?.contentMode = .scaleAspectFit
    chatButton.imageEdgeInsets = .zero
    chatButton.contentVerticalAlignment = .fill
    chatButton.contentHorizontalAlignment = .fill
    chatButton.tintColor = .black
    containerView.addSubview(chatButton)

    chatButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      chatButton.leadingAnchor.constraint(equalTo: favoriteButton.trailingAnchor, constant: 12),
      chatButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
      chatButton.widthAnchor.constraint(equalToConstant: 32),
      chatButton.heightAnchor.constraint(equalToConstant: 32),
    ])

    // Recipe Details

    recipeDetailsTitleLabel.text = "Recipe Details"
    recipeDetailsTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    containerView.addSubview(recipeDetailsTitleLabel)

    recipeDetailsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      recipeDetailsTitleLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 12
      ),
      recipeDetailsTitleLabel.topAnchor.constraint(
        equalTo: favoriteButton.bottomAnchor,
        constant: 24
      ),
    ])

    recipeDetailsContentLabel.text = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce aliquet et felis eget congue. Sed ac egestas ante. Aenean semper augue vitae purus ultricies, sit amet convallis mauris suscipit. Mauris faucibus venenatis turpis, at elementum ipsum mollis ac. Aenean consequat, dolor in rutrum dignissim, magna libero consequat magna, semper convallis erat lorem sed justo. Mauris augue purus, faucibus in mauris vel, posuere ornare diam. Maecenas pharetra tortor quis felis porta gravida. Cras ut nunc in dui ornare varius in in orci. Pellentesque ultrices, nibh nec volutpat egestas, magna lorem sodales ipsum, ultricies laoreet neque erat a mi. Donec pulvinar metus eros, vel faucibus tellus malesuada ac.
    """
    recipeDetailsContentLabel.font = UIFont.systemFont(ofSize: 14)
    recipeDetailsContentLabel.lineBreakMode = .byWordWrapping
    recipeDetailsContentLabel.lineBreakStrategy = .standard
    recipeDetailsContentLabel.numberOfLines = 1024
    containerView.addSubview(recipeDetailsContentLabel)

    recipeDetailsContentLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      recipeDetailsContentLabel.topAnchor.constraint(
        equalTo: recipeDetailsTitleLabel.bottomAnchor,
        constant: 8
      ),
      recipeDetailsContentLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: 12
      ),
      recipeDetailsContentLabel.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -12
      ),
    ])

    // Notes

    notesLabel.text = "Notes"
    notesLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    notesLabel.isHidden = true
    containerView.addSubview(notesLabel)

    notesLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      notesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
      notesLabel.topAnchor.constraint(
        equalTo: recipeDetailsContentLabel.bottomAnchor,
        constant: 24
      ),
    ])

    notesTextView.textAlignment = .left
    notesTextView.font = UIFont.systemFont(ofSize: 14)
    notesTextView.layer.borderWidth = 2
    notesTextView.layer.borderColor = UIColor.black.cgColor
    notesTextView.isScrollEnabled = false
    notesTextView.isHidden = true
    containerView.addSubview(notesTextView)

    notesTextView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      notesTextView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 8),
      notesTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
      notesTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
      notesTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
    ])

    // Container Constraint

    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerViewBottomConstraintWithNotes = containerView.bottomAnchor.constraint(
      equalTo: notesTextView.bottomAnchor,
      constant: 24
    )
    containerViewBottomConstraintWithoutNotes = containerView.bottomAnchor.constraint(
      equalTo: recipeDetailsContentLabel.bottomAnchor,
      constant: 24
    )
    NSLayoutConstraint.activate([
      containerViewBottomConstraintWithoutNotes,
      containerView.widthAnchor.constraint(equalTo: widthAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func updateData(_ recipeDetailModel: RecipeDetailModel) {
    titleLabel.text = recipeDetailModel.title
    if let image = try? UIImage(data: Data(contentsOf: recipeDetailModel.mainImage)) {
      imageView.image = image
    } else {
      imageView.backgroundColor = .systemGray
    }

    if recipeDetailModel.isFavorited {
      UIView.performWithoutAnimation { setRecipeAsFavorite() }
      initialNotesText = recipeDetailModel.userNote
      notesTextView.text = initialNotesText
    } else {
      UIView.performWithoutAnimation { unsetRecipeAsFavorite() }
    }

    if let summary = recipeDetailModel.summary {
      recipeDetailsTitleLabel.text = "Summary"
      recipeDetailsContentLabel.text = summary
    }

    containerView.isHidden = false
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    recipeDetailsContentLabel.sizeToFit()
    notesTextView.sizeToFit()
    contentSize = containerView.frame.size
  }

  // MARK: - Target Actions

  @objc func favoriteButtonDidTap(_ sender: Any?) {
    recipeDetailViewDelegate?.favoriteButtonDidTap(favoriteButton)
  }

  // MARK: - Public Methods

  public func setRecipeAsFavorite() {
    favoriteButton.isSelected = true

    notesLabel.isHidden = false
    notesTextView.isHidden = false
    notesLabel.layer.opacity = 0
    notesTextView.layer.opacity = 0

    UIView.animate(withDuration: 0.3) {
      self.notesLabel.layer.opacity = 1
      self.notesTextView.layer.opacity = 1
      self.containerViewBottomConstraintWithoutNotes.isActive = false
      self.containerViewBottomConstraintWithNotes.isActive = true
      self.layoutIfNeeded()
    }
  }

  public func unsetRecipeAsFavorite() {
    favoriteButton.isSelected = false

    UIView.animate(withDuration: 0.3) {
      self.notesLabel.layer.opacity = 0
      self.notesTextView.layer.opacity = 0
      self.containerViewBottomConstraintWithoutNotes.isActive = true
      self.containerViewBottomConstraintWithNotes.isActive = false
      self.layoutIfNeeded()
    } completion: { (completed) in
      self.notesTextView.text = nil
      self.notesLabel.isHidden = true
      self.notesTextView.isHidden = true
    }
  }

  public var isNotesChanged: Bool {
    let previouslyEmpty = initialNotesText == nil || initialNotesText == ""
    let currentlyEmpty = notesTextView.text == nil || notesTextView.text == ""

    return (!previouslyEmpty || !currentlyEmpty)  && initialNotesText != notesTextView.text
  }

  public var isNotesEmpty: Bool {
    return notesTextView.text == nil || notesTextView.text == ""
  }

  // MARK: - Helper

  func ratingToString(ratingAverage: Float, ratingCount: Int) -> String {
    if ratingCount >= 1000000 {
      return String(format: "%.1lf / %.1lfM Ratings", ratingAverage, Float(ratingCount) / 1000000.0)
    } else if ratingCount >= 1000 {
      return String(format: "%.1lf / %.1lfK Ratings", ratingAverage, Float(ratingCount) / 1000.0)
    } else {
      return String(format: "%.1lf / %d Ratings", ratingAverage, ratingCount)
    }
  }
}
