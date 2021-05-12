//
//  MessagesViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/20.
//

import UIKit

public class MessagesViewController: UIViewController, UITextFieldDelegate {

  var messagesCollectionViewManager: MessagesCollectionViewManager!

  var dismissTextEditingTapRecognizer: UIGestureRecognizer?

  public override func loadView() {
    let messagesView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    messagesView.contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12)
    messagesView.backgroundColor = .white

    messagesCollectionViewManager = MessagesCollectionViewManager(
      viewController: self,
      collectionView: messagesView
    )
    messagesCollectionViewManager.textFieldDelegate = self
    messagesView.delegate = messagesCollectionViewManager
    messagesView.dataSource = messagesCollectionViewManager

    self.view = messagesView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    title = "Messages"

    // Shows load indicator only on first load
    LoadingOverlayView.startOverlay()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      LoadingOverlayView.stopOverlay()
    }
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    fetchRecentMessages()
  }

  // MARK: - Data Fetch

  func fetchRecentMessages() {
    MessageServices.sharedInstance.getRecentMessagesList(
      forUserID: AccountManager.sharedInstance.currentUserID) { recentMessages in
      self.messagesCollectionViewManager.updateRecentMessages(recentMessages)
    }
  }

  func fetchSearchUsername(withQuery query: String) {
    UserServices.sharedInstance.searchUsername(withQuery: query) { searchUsernameModels in
      self.messagesCollectionViewManager.updateSearchedUsernames(searchUsernameModels)
    }
  }

  func clearSearchedUsername() {
    messagesCollectionViewManager.updateSearchedUsernames([])
  }

  // MARK: - UITextFieldDelegate

  @objc func dismissTextEditing(_ sender: Any?) {
    view.endEditing(true)
  }

  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    dismissTextEditingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTextEditing(_:)))
    navigationController?.view.addGestureRecognizer(dismissTextEditingTapRecognizer!)
    return true
  }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    if let _ = dismissTextEditingTapRecognizer {
      navigationController?.view.removeGestureRecognizer(dismissTextEditingTapRecognizer!)
    }
    dismissTextEditingTapRecognizer = nil

    if let query = textField.text, query.count > 0 {
      fetchSearchUsername(withQuery: query)
    } else {
      clearSearchedUsername()
    }
  }

  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
