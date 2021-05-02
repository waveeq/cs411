//
//  RecipeThumbnailCell.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/05/01.
//

import UIKit

public class RecipeThumbnailCell: UICollectionViewCell {

  let imageView = UIImageView()

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    imageView.backgroundColor = UIColor(white: 0, alpha: 0.1)
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    contentView.addSubview(imageView)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
  }

  public func loadImageAsync(
    forRecipeID recipeID: Int,
    url: URL
  ) {
    RecipeServices.sharedInstance.loadImageData(
      forRecipeID: recipeID,
      url: url) { image in
      self.imageView.image = image
    }
  }
}
