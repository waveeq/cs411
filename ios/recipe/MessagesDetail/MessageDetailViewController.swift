//
//  MessageDetailViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/24.
//

import SocketIO
import UIKit

public class MessageDetailViewController: UIViewController,
                                          MessageBubbleCellDelegate,
                                          MessageDetailViewDelegate,
                                          UICollectionViewDataSource,
                                          UICollectionViewDelegateFlowLayout {

  let cellIdentifier = "messageBubbleCellIdentifer"

  let friendModel: OldFriendModel
  var recipeDetailModelToShare: RecipeDetailModel?

  var socketManager : SocketManager!
  var socket: SocketIOClient!

  var dismissTextEditingTapRecognizer: UIGestureRecognizer?

  var messageBubbles: [MessageBubbleModel] = []

  public required init(friend: OldFriendModel) {
    self.friendModel = friend

    super.init(nibName: nil, bundle: nil)

    navigationItem.largeTitleDisplayMode = .never
    navigationItem.leftItemsSupplementBackButton = true
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      customView: MessageNavBarFriendView(friend: friend)
    )
  }

  public convenience init(friend: OldFriendModel, shareRecipe recipeDetailModel: RecipeDetailModel) {
    self.init(friend: friend)

    recipeDetailModelToShare = recipeDetailModel
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func loadView() {
    let messageDetailView = MessageDetailView()
    messageDetailView.delegate = self

    view = messageDetailView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    let messageDetailView = view as! MessageDetailView

    let collectionView = messageDetailView.collectionView
    collectionView.register(MessageBubbleCell.self, forCellWithReuseIdentifier: cellIdentifier)
    collectionView.delegate = self
    collectionView.dataSource = self

    // Navigation Bar cover
    connectSocketIO()
  }

  func connectSocketIO() {
    socketManager = SocketManager(
      socketURL: URL(string: MessageServices.socketIOEndpoint)!,
      config: [.log(true), .compress]
    )
    print("endpoint = ", MessageServices.socketIOEndpoint)
    socket = socketManager.socket(forNamespace: MessageServices.socketIONamespace)

    socket.on("connect") { data, ack in
      self.socket.emit(
        "joined",
        SocketJoinRoomModel(
          sender: AccountManager.sharedInstance.currentUserID,
          friend: self.friendModel.userID
        )
      )
      self.logSocketData(data)

      if let recipeDetailModel = self.recipeDetailModelToShare {
        print("===== share model: \(recipeDetailModel)")
        self.socket.emit(
          "text",
          MessageBubbleModel(
            sender: AccountManager.sharedInstance.currentUserID,
            friend: self.friendModel.userID,
            isText: false,
            date: Date(),
            text: nil,
            recipeID: recipeDetailModel.recipeID,
            recipeName: recipeDetailModel.title,
            recipeImageURL: recipeDetailModel.mainImage.absoluteString
          )
        )
      }
    }

    socket.on("status") { data, ack in
      self.logSocketData(data)
    }

    socket.on("message") { data, ack in
      self.addNewMessageFromSocketData(data)
    }

    socket.connect()
  }

  func logSocketData(_ data: [Any]) {
    guard let dict = data.first as? [String:Any] else { return }

    print("===== log socket data: \(String(describing: dict))")
  }

  func addNewMessageFromSocketData(_ data: [Any]) {

    guard let dict = data.first as? [String:Any],
          let sender = dict["sender"] as? Int,
          let friend = dict["friend"] as? Int,
          let isText = dict["isText"] as? Bool,
          let dateTimeEpoch = dict["date"] as? TimeInterval
    else {
      print("===== invalid socket data format: \(data)")
      return
    }

    let messageBubbleModel = MessageBubbleModel(
      sender: sender,
      friend: friend,
      isText: isText,
      date: Date(timeIntervalSince1970: dateTimeEpoch),
      text: dict["text"] as? String,
      recipeID: dict["recipeID"] as? Int,
      recipeName: dict["recipeName"] as? String,
      recipeImageURL: dict["recipeImageURL"] as? String
    )

    messageBubbles.append(messageBubbleModel)

    let messageDetailView = view as! MessageDetailView
    let collectionView = messageDetailView.collectionView

    collectionView.reloadData()
    collectionView.setNeedsLayout()
  }

  // MARK: - MessageBubbleCellDelegate

  public func openSharedRecipePage(forRecipeID recipeID: Int) {
    present(RecipeDetailViewController(recipeID: recipeID), animated: true)
  }

  // MARK: - MessageDetailViewDelegate

  public func sendButtonDidTap(_ sendButton: UIButton, textView: UITextView) {
    let messageDetailView = view as! MessageDetailView
    socket.emit(
      "text",
      MessageBubbleModel(
        sender: AccountManager.sharedInstance.currentUserID,
        friend: self.friendModel.userID,
        isText: true,
        date: Date(),
        text: textView.text,
        recipeID: nil
      )
    )

    textView.text = nil
    messageDetailView.updateOnTextViewChange()
  }

  // MARK: - UICollectionViewDataSource

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return messageBubbles.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: cellIdentifier,
      for: indexPath
    ) as! MessageBubbleCell
    cell.delegate = self
    cell.configure(with: messageBubbles[indexPath.row])

    return cell
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
    return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return MessageBubbleCell.preferredSize(
      forModel: messageBubbles[indexPath.row],
      parentView: view
    )
  }

  // MARK: - UITextViewDelegate

  @objc func dismissTextEditing(_ sender: Any?) {
    view.endEditing(true)
  }

  public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    dismissTextEditingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTextEditing(_:)))
    view.addGestureRecognizer(dismissTextEditingTapRecognizer!)
    return true
  }

  public func textViewDidChange(_ textView: UITextView) {
    let messageDetailView = view as! MessageDetailView
    messageDetailView.updateOnTextViewChange()
  }

  public func textViewDidEndEditing(_ textView: UITextView) {
    if let _ = dismissTextEditingTapRecognizer {
      view.removeGestureRecognizer(dismissTextEditingTapRecognizer!)
    }
    dismissTextEditingTapRecognizer = nil
  }

  public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    textView.resignFirstResponder()
    return true
  }
}
