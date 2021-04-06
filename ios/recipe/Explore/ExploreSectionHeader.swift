//
//  ExploreSectionHeader.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/21.
//

import UIKit

public class ExploreSectionHeader: UICollectionReusableView {

  static let searchBarHeight: CGFloat = 52
  static let filterListHeight: CGFloat = 44

  public static var headerHeight: CGFloat {
    return searchBarHeight + 12 + filterListHeight
  }

  var filterCollectionViewManager: ExploreFilterCollectionViewManager!

  lazy var textField: ExploreSearchBar = {
    let textField = ExploreSearchBar()
    textField.backgroundColor = UIColor.white
    textField.layer.borderWidth = 2
    textField.layer.borderColor = UIColor.black.cgColor
    return textField
  }()

  lazy var filterCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal

    let filterCollectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    filterCollectionView.showsHorizontalScrollIndicator = false
    filterCollectionView.clipsToBounds = false
    
    filterCollectionViewManager = ExploreFilterCollectionViewManager(
      collectionView: filterCollectionView
    )
    filterCollectionView.delegate = filterCollectionViewManager
    filterCollectionView.dataSource = filterCollectionViewManager

    return filterCollectionView
  }()

  weak var textFieldDelegate: UITextFieldDelegate? {
    didSet {
      textField.delegate = textFieldDelegate
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white
    clipsToBounds = false

    addSubview(textField)

    textField.placeholder = "Enter recipe keywords..."
    textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 8, height: 8)))
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: topAnchor),
      textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      textField.heightAnchor.constraint(equalToConstant: Self.searchBarHeight),
    ])
    textField.delegate = textFieldDelegate

    addSubview(filterCollectionView)

    filterCollectionView.backgroundColor = .white

    filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      filterCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      filterCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      filterCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      filterCollectionView.heightAnchor.constraint(equalToConstant: Self.filterListHeight),
    ])
    filterCollectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
