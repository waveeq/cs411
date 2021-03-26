//
//  ExploreFilterCell.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/26.
//

import UIKit

public class ExploreFilterCell: UICollectionViewCell {

  let label = UILabel()

  required init?(coder: NSCoder) {
    fatalError("nope!")
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white

    layer.borderWidth = 1
    layer.borderColor = UIColor.black.cgColor
    layer.cornerRadius = 8
    clipsToBounds = false

    contentView.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: centerYAnchor),
      label.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])

    label.font = UIFont.systemFont(ofSize: 14)
    label.adjustsFontSizeToFitWidth = false
    label.numberOfLines = 1
    label.sizeToFit()
  }

  public override var intrinsicContentSize: CGSize {
    return CGSize(width: label.bounds.width + 16, height: 44)
  }
}
