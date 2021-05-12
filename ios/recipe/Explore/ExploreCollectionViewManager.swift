//
//  ExploreCollectionViewManager.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/21.
//

import UIKit

// TODO(Dikra): Re-enable search bar header
class ExploreCollectionViewManager: NSObject,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {

  let cellIdentifier = "exploreCellIdentifer"
  let headerIdentifier = "exploreHeaderIdentifier"

  var exploreModels: [ExploreModel] = []

  weak var textFieldDelegate: UITextFieldDelegate?
  weak var viewController: UIViewController?
  weak var collectionView: UICollectionView?

  public required init(viewController: UIViewController, collectionView: UICollectionView) {
    super.init()

    self.viewController = viewController
    self.collectionView = collectionView

    collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    
    collectionView.register(RecipeThumbnailCell.self, forCellWithReuseIdentifier: cellIdentifier)
    collectionView.register(
      ExploreSectionHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: headerIdentifier
    )
  }

  public func updateData(exploreModels: [ExploreModel]) {
    self.exploreModels = exploreModels
    collectionView?.reloadData()
  }

  // MARK: - UICollectionViewDataSource

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return exploreModels.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: cellIdentifier,
      for: indexPath
    ) as! RecipeThumbnailCell
    cell.loadImageAsync(
      forRecipeID: exploreModels[indexPath.row].recipeID,
      url: exploreModels[indexPath.row].mainImage
    )
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let sectionHeader = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: headerIdentifier,
        for: indexPath
      ) as! ExploreSectionHeader
      sectionHeader.textFieldDelegate = textFieldDelegate
      return sectionHeader
    } else {
      return UICollectionReusableView()
    }
  }

  // MARK: - UICollectionViewDelegate

  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    viewController?.present(
      RecipeDetailViewController(recipeID: exploreModels[indexPath.row].recipeID),
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
    return UIEdgeInsets(
      top: 8,
      left: 12,
      bottom: 8,
      right: 12
    )
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let cellSize = (collectionView.frame.size.width / 3) - 16
    return CGSize(width: cellSize, height: cellSize)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: ExploreSectionHeader.headerHeight)
  }
}

