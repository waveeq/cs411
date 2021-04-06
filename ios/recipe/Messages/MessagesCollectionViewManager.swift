//
//  MessagesCollectionViewManager.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/21.
//

import UIKit

public struct MessageData {
  var name: String
  var image: UIImage
  var recentChat: String
  var recentChatTime: String
}

public class MessagesCollectionViewManager: NSObject,
                                            UICollectionViewDataSource,
                                            UICollectionViewDelegate,
                                            UICollectionViewDelegateFlowLayout {

  let cellIdentifier = "messagesCellIdentifer"
  let headerIdentifier = "messagesHeaderIdentifier"

  lazy var tempMessages: [MessageData] = {
    let data = [
      MessageData(
        name: "Eva",
        image: UIImage(named: "avatar_placeholder")!,
        recentChat: "I've been looking for this recipe my whole life. Thank you!",
        recentChatTime: "・5m"
      ),
      MessageData(
        name: "Maggie",
        image: UIImage(named: "avatar_placeholder")!,
        recentChat: "Thanks :)",
        recentChatTime: "・30m"
      ),
      MessageData(
        name: "Jessica",
        image: UIImage(named: "avatar_placeholder")!,
        recentChat: "Loved this app!!",
        recentChatTime: "・2h"
      ),
    ]
    return [[MessageData]](repeating: data, count: 4).flatMap{$0}
  }()

  weak var textFieldDelegate: UITextFieldDelegate?
  weak var viewController: UIViewController?

  required init(viewController: UIViewController, collectionView: UICollectionView) {
    super.init()

    self.viewController = viewController
    
    collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellIdentifier)
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

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tempMessages.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MessageCell

    cell.nameLabel.text = tempMessages[indexPath.row].name
    cell.recentChatLabel.text = tempMessages[indexPath.row].recentChat
    cell.recentChatTimeLabel.text = tempMessages[indexPath.row].recentChatTime

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
      MessageDetailViewController(messageData: tempMessages[indexPath.row]),
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
    return UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: MessageCell.height)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    let collectionViewSafeArea = collectionView.frame.inset(by: collectionView.adjustedContentInset)
    return CGSize(width: collectionViewSafeArea.width, height: MessagesSectionHeader.searchBarHeight)
  }
}

