//
//  ExploreCollectionViewManager.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/21.
//

import UIKit

class ExploreCollectionViewManager: NSObject,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {

  let cellIdentifier = "exploreCellIdentifer"
  let headerIdentifier = "exploreHeaderIdentifier"

  lazy var tempCellColors: [UIColor] = {
    var colors: [UIColor] = []
    for _ in 1...60 {
      colors.append(randomColor())
    }
    return colors
  }()

  weak var textFieldDelegate: UITextFieldDelegate?
  weak var viewController: UIViewController?

  public required init(viewController: UIViewController, collectionView: UICollectionView) {
    super.init()

    self.viewController = viewController
    
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    collectionView.register(
      ExploreSectionHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: headerIdentifier
    )
  }

  // MARK: - UICollectionViewDataSource

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return tempCellColors.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    cell.backgroundColor = tempCellColors[indexPath.row]

    return cell
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: headerIdentifier,
        for: indexPath
      ) as! ExploreSectionHeader

      header.textFieldDelegate = textFieldDelegate
      return header
    } else { //No footer in this case but can add option for that
         return UICollectionReusableView()
    }
  }

  // MARK: - UICollectionViewDelegate

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewController?.navigationController?.pushViewController(
      RecipeDetailViewController(recipeImageColor: tempCellColors[indexPath.row]),
      animated: true
    )
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
    return UIEdgeInsets(top: 16, left: 12, bottom: 32, right: 12)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let cellSize = (collectionView.frame.size.width / 3) - 16
    return CGSize(width: cellSize, height: cellSize)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    let collectionViewSafeArea = collectionView.frame.inset(by: collectionView.adjustedContentInset)
    return CGSize(width: collectionViewSafeArea.width, height: ExploreSectionHeader.headerHeight)
  }

  // custom function to generate a random UIColor
  public func randomColor() -> UIColor{
      let red = CGFloat(drand48())
      let green = CGFloat(drand48())
      let blue = CGFloat(drand48())
      return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
  }
}

