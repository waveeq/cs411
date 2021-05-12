//
//  ShareSelectFriendCollectioinViewManager.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/05/03.
//

import UIKit

public class ShareSelectFriendCollectionViewManager: NSObject,
                                                     UICollectionViewDataSource,
                                                     UICollectionViewDelegate,
                                                     UICollectionViewDelegateFlowLayout {

  let cellIdentifier = "shareSelectFriendCellIdentifer"
  let headerIdentifier = "shareSelectFriendHeaderIdentifier"

  var searchedUsernames: [SearchUsernameModel] = []

  let recipeDetailModel: RecipeDetailModel

  weak var textFieldDelegate: UITextFieldDelegate?
  weak var viewController: UIViewController?
  weak var collectionView: UICollectionView?

  required init(viewController: UIViewController, collectionView: UICollectionView, recipeDetailModel: RecipeDetailModel) {
    self.recipeDetailModel = recipeDetailModel

    super.init()

    self.viewController = viewController
    self.collectionView = collectionView

    collectionView.register(ShareSelectFriendCell.self, forCellWithReuseIdentifier: cellIdentifier)
    collectionView.register(
      ShareSelectFriendHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: headerIdentifier
    )
  }

  // MARK: - Data Update

  public func updateSearchedUsernames(_ searchedUsernames: [SearchUsernameModel]) {
    self.searchedUsernames = searchedUsernames
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
    return searchedUsernames.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: cellIdentifier,
      for: indexPath
    ) as! ShareSelectFriendCell
    cell.configure(with: searchedUsernames[indexPath.row])
    return cell
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let header =  collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: headerIdentifier,
        for: indexPath
      ) as! ShareSelectFriendHeader
      header.textFieldDelegate = textFieldDelegate
      return header
    } else {
         return UICollectionReusableView()
    }
  }

  // MARK: - UICollectionViewDelegate

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewController?.rootViewController?.shareRecipe(
      recipeDetailModel,
      toFriendID: searchedUsernames[indexPath.row].userID
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
    return UIEdgeInsets(top: 8, left: 12, bottom: 32, right: 12)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: ShareSelectFriendCell.height)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: ShareSelectFriendHeader.searchBarHeight)
  }
}

