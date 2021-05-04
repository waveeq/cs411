//
//  ExploreFilterCollectionViewManager.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/21.
//

import UIKit

public class ExploreFilterCollectionViewManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  let cellIdentifier = "exploreFilterCellIdentifer"
  var activatedFilterIndexPath: IndexPath?

  let tempFilterNames: [String] = [
    "All Results",
    "Breakfast",
    "Lunch",
    "Dinner",
    "Vegetarian",
    "Low Carbs"
  ]

  public required init(collectionView: UICollectionView) {
    super.init()

    collectionView.register(ExploreFilterCell.self, forCellWithReuseIdentifier: cellIdentifier)
  }

  // MARK: - UICollectionViewDataSource

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return tempFilterNames.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: cellIdentifier,
      for: indexPath
    ) as! ExploreFilterCell
    cell.label.text = tempFilterNames[indexPath.row]

    // At zero-state, the "All Results" filter should be marked as activated.
    if indexPath.row == 0 && activatedFilterIndexPath == nil {
      cell.activated = true
      activatedFilterIndexPath = indexPath
    }

    return cell
  }

  // MARK: - UICollectionViewDelegate

  public func collectionView(
    _ collectionView: UICollectionView,
    didHighlightItemAt indexPath: IndexPath
  ) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? ExploreFilterCell else { return }
    cell.highlight = true
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    didUnhighlightItemAt indexPath: IndexPath
  ) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? ExploreFilterCell else { return }
    cell.highlight = false
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? ExploreFilterCell else { return }

    if let previouslyActivatedFilterIndexPath = activatedFilterIndexPath,
       let previouslyActivatedCell =
         collectionView.cellForItem(at: previouslyActivatedFilterIndexPath) as? ExploreFilterCell {
      previouslyActivatedCell.activated = false
    }

    cell.activated = true
    activatedFilterIndexPath = indexPath
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 12
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 12
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let textWidth = tempFilterNames[indexPath.row].size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
    return CGSize(width: textWidth.width + 20, height: 44)
  }
}
