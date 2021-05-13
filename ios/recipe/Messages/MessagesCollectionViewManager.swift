//
//  MessagesCollectionViewManager.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/21.
//

import UIKit

public class MessagesCollectionViewManager: NSObject,
                                            UICollectionViewDataSource,
                                            UICollectionViewDelegate,
                                            UICollectionViewDelegateFlowLayout {

  let cellIdentifier = "messagesCellIdentifer"
  let headerIdentifier = "messagesHeaderIdentifier"

  var recentMessages: [MessageModel] = []
  var searchedUsernames: [SearchUsernameModel] = []
  weak var textFieldDelegate: UITextFieldDelegate?
  weak var viewController: UIViewController?
  weak var collectionView: UICollectionView?

  required init(viewController: UIViewController, collectionView: UICollectionView) {
    super.init()

    self.viewController = viewController
    self.collectionView = collectionView
    
    collectionView.register(RecentMessageCell.self, forCellWithReuseIdentifier: cellIdentifier)
    collectionView.register(
      MessagesSectionHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: headerIdentifier
    )
  }

  // MARK: - Data Update

  public func updateRecentMessages(_ recentMessages: [MessageModel]) {
    self.recentMessages = recentMessages
    collectionView?.reloadData()
  }

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
    return searchedUsernames.count > 0 ? searchedUsernames.count : recentMessages.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: cellIdentifier,
      for: indexPath
    ) as! RecentMessageCell

    if searchedUsernames.count > 0 {
      if let recentMessage = recentMessages.first(
          where: {
            $0.friendID == searchedUsernames[indexPath.row].userID
            || $0.senderID == searchedUsernames[indexPath.row].userID
          }) {
        cell.configure(with: recentMessage)
      } else {
        cell.configure(with: searchedUsernames[indexPath.row])
      }
    } else {
      cell.configure(with: recentMessages[indexPath.row])
    }
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
      ) as! MessagesSectionHeader
      header.textFieldDelegate = textFieldDelegate
      return header
    } else { //No footer in this case but can add option for that
         return UICollectionReusableView()
    }
  }

  // MARK: - UICollectionViewDelegate

  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    var friendID: Int!

    if searchedUsernames.count > 0 {
      friendID = searchedUsernames[indexPath.row].userID
    } else {
      if recentMessages[indexPath.row].senderID != AccountManager.sharedInstance.currentUserID {
        friendID = recentMessages[indexPath.row].senderID
      } else {
        friendID = recentMessages[indexPath.row].friendID
      }
    }

    viewController?.navigationController?.pushViewController(
      MessageDetailViewController(friendID: friendID),
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
    return UIEdgeInsets(top: 8, left: 12, bottom: 32, right: 12)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: RecentMessageCell.height)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: MessagesSectionHeader.searchBarHeight)
  }
}

