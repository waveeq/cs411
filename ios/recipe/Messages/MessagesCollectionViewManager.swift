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

  lazy var recentMessages: [OldRecentMessageModel] = {
    let data = [
      OldRecentMessageModel(
        friend: OldFriendModel(
          userID: 2,
          name: "Eva",
          profilePicture: nil
        ), message: OldMessageModel(
          date: Date(timeIntervalSinceNow: -5.0 * 60.0),
          isText: true,
          text: "I've been looking for this recipe my whole life. Thank you!",
          recipeID: nil,
          mainImage: nil,
          summary: nil
        )
//        name: "Eva",
//        image: UIImage(named: "avatar_placeholder")!,
//        recentChat: "I've been looking for this recipe my whole life. Thank you!",
//        recentChatTime: "・5m"
      ),
      OldRecentMessageModel(
        friend: OldFriendModel(
          userID: 3,
          name: "Maggie",
          profilePicture: nil
        ), message: OldMessageModel(
          date: Date(timeIntervalSinceNow: -30.0 * 60.0),
          isText: true,
          text: "Thanks :)",
          recipeID: nil,
          mainImage: nil,
          summary: nil
        )
//      MessageData(
//        name: "Maggie",
//        image: UIImage(named: "avatar_placeholder")!,
//        recentChat: "Thanks :)",
//        recentChatTime: "・30m"
      ),
      OldRecentMessageModel(
        friend: OldFriendModel(
          userID: 4,
          name: "Jessica",
          profilePicture: nil
        ), message: OldMessageModel(
          date: Date(timeIntervalSinceNow: -2 * 3600.0),
          isText: true,
          text: "Loved this app!!",
          recipeID: nil,
          mainImage: nil,
          summary: nil
        )
//      MessageData(
//        name: "Jessica",
//        image: UIImage(named: "avatar_placeholder")!,
//        recentChat: "Loved this app!!",
//        recentChatTime: "・2h"
      ),
    ]
    return data
  }()

  weak var textFieldDelegate: UITextFieldDelegate?
  weak var viewController: UIViewController?

  required init(viewController: UIViewController, collectionView: UICollectionView) {
    super.init()

    self.viewController = viewController
    
    collectionView.register(RecentMessageCell.self, forCellWithReuseIdentifier: cellIdentifier)
    collectionView.register(
      MessagesSectionHeader.self,
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
    return recentMessages.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: cellIdentifier,
      for: indexPath
    ) as! RecentMessageCell

    cell.configure(with: recentMessages[indexPath.row])
    
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

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewController?.navigationController?.pushViewController(
      MessageDetailViewController(friend: recentMessages[indexPath.row].friend),
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

