//
//  RatingView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import UIKit

public class RatingStarsView: UIView {

  var starViews: [UIImageView]!

  public override init(frame: CGRect) {
    super.init(frame: .zero)

    starViews = []
    
    for i in 0...4 {
      let starView = UIImageView(image: UIImage(systemName: "star.fill"))
      starView.tintColor = .black
      addSubview(starView)

      starView.translatesAutoresizingMaskIntoConstraints = false
      let starViewLeadingAnchor =
        i == 0 ? starView.leadingAnchor.constraint(equalTo: leadingAnchor)
               : starView.leadingAnchor.constraint(
                    equalTo: starViews[i-1].trailingAnchor,
                    constant: 2
                 )
      NSLayoutConstraint.activate([
        starViewLeadingAnchor,
        starView.topAnchor.constraint(equalTo: topAnchor),
        starView.heightAnchor.constraint(equalTo: heightAnchor),
        starView.widthAnchor.constraint(equalTo: heightAnchor),
      ])

      starViews.append(starView)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
