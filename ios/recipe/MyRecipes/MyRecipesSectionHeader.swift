//
//  MyRecipesSectionHeader.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/26.
//

import UIKit

public class MyRecipesSectionHeader: UICollectionReusableView {

  public static let height: CGFloat = 40

  var label: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
    label.sizeToFit()
    return label
  }()

  public override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor),
      label.leadingAnchor.constraint(equalTo: leadingAnchor),
      label.trailingAnchor.constraint(equalTo: trailingAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
