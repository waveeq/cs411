//
//  MessagesSectionHeader.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/21.
//

import UIKit

public class MessagesSectionHeader: UICollectionReusableView {

  static let searchBarHeight: CGFloat = 52

  var filterCollectionViewManager: ExploreFilterCollectionViewManager!

  lazy var textField: MessagesSearchBar = {
    let textField = MessagesSearchBar()
    textField.backgroundColor = UIColor.white
    textField.layer.borderWidth = 2
    textField.layer.borderColor = UIColor.black.cgColor
    return textField
  }()

  weak var textFieldDelegate: UITextFieldDelegate? {
    didSet {
      textField.delegate = textFieldDelegate
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white

    addSubview(textField)

    textField.placeholder = "Enter friend username..."
    textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 8, height: 8)))
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: topAnchor),
      textField.leadingAnchor.constraint(equalTo: leadingAnchor),
      textField.trailingAnchor.constraint(equalTo: trailingAnchor),
      textField.heightAnchor.constraint(equalToConstant: Self.searchBarHeight),
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
