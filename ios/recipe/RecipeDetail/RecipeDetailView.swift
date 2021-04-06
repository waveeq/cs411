//
//  RecipeDetailView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/26.
//

import UIKit

public class RecipeDetailView: UIScrollView {

  let contentPadding: CGFloat = 12
  var imageView: UIView!

  public override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white

    imageView = UIView()
    addSubview(imageView)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: contentPadding),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentPadding),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentPadding),
      imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -2*contentPadding),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    let height = imageView.bounds.size.height + 2 * contentPadding
    contentSize = CGSize(width: bounds.width, height: height)
  }
}
